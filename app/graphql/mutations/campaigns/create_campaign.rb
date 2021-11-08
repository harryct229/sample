# frozen_string_literal: true

module Mutations
  module Campaigns
    class CreateCampaign < Mutations::BaseMutation
      description 'Create a campaign'
      argument :group_id, ID, required: true
      argument :payment_method_id, String, required: false
      argument :attributes, Types::Campaigns::CampaignInputType, required: true

      field :errors, [::Types::Auth::Error], null: false
      field :success, Boolean, null: false
      field :campaign, Types::Groups::GroupType, null: false
      field :payment_intent, GraphQL::Types::JSON, null: false

      def resolve(group_id:, payment_method_id:, attributes:)
        user = context[:current_user]
        campaign_attributes = attributes.to_h
        group = ::Group.accessible_by(current_ability).find_by(id: group_id)

        if group.nil?
          raise ActiveRecord::RecordNotFound,
            I18n.t('errors.messages.resource_not_found', resource: ::Group.model_name.human)
        end

        current_ability.authorize! :create_campaign, group

        puts campaign_attributes

        begin
          ActiveRecord::Base.transaction do
            campaign_podcast_categories_attributes = campaign_attributes[:podcast_categories].map do |item|
              {
                podcast_category_id: item[:id]
              }
            end

            campaign = Campaign.new(
              state: "created",
              created_by: user,
              group: group,
              budget: campaign_attributes[:budget],
              budget_distributions: campaign_attributes[:budget_distributions],
              country: Country.find_by!(code: campaign_attributes[:country]),
              language: Language.find_by!(code: campaign_attributes[:language]),
              creative_option: campaign_attributes[:creative_option],
              name: campaign_attributes[:name],
              description: campaign_attributes[:description],
              objective: campaign_attributes[:objective],
              website: campaign_attributes[:website],
              start_date: campaign_attributes[:start_date],
              end_date: campaign_attributes[:end_date],
              sponsorship_logo: campaign_attributes[:sponsorship_logo],
              campaign_podcast_categories_attributes: campaign_podcast_categories_attributes,
            )

            if campaign.creative_option == "host_read_ad"
              campaign.script = campaign_attributes[:script]
            elsif campaign.creative_option == "audio_ad"
              campaign.audio = campaign_attributes[:audio]
            end

            campaign.save!

            if payment_method_id
              group.attach_payment(payment_method_id)
            end

            amount = (attributes[:budget] * 100).to_i

            payment_intent = Stripe::PaymentIntent.create({
              amount: amount,
              currency: 'usd',
              customer: group.stripe_customer_id,
              payment_method: payment_method_id,
              description: "CAMPAIGN: %s" % campaign.name,
              receipt_email: group.email,
              confirm: true,
              metadata: {
                user_id: user.id,
                group_id: group.id,
                campaign_id: campaign.id
              }
            })

            return {
              errors: campaign.errors.messages.map do |field, messages|
                { 
                  field: field.to_s.camelize(:lower),
                  message: campaign.errors.full_message(field, messages.first),
                }
              end,
              success: campaign.errors.blank?,
              campaign: campaign.errors.blank? ? campaign : nil,
              payment_intent: payment_intent
            }
          end

        rescue ActiveRecord::RecordInvalid => exception
          return {
            errors: [
              { 
                message: exception.message,
              }
            ],
            success: false,
            campaign: nil,
            payment_intent: nil
          }
        end
      end
    end
  end
end
