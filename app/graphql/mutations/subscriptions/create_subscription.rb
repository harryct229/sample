# frozen_string_literal: true

module Mutations
  module Subscriptions
    class CreateSubscription < Mutations::BaseMutation
      description 'Subcribe to a plan'
      argument :group_id, ID, required: true
      argument :price_nickname, String, required: true
      argument :promotion_code, String, required: false
      argument :payment_method_id, String, required: false

      field :errors, [::Types::Auth::Error], null: false
      field :success, Boolean, null: false
      field :group, Types::Groups::GroupType, null: false
      field :stripe_subscription, GraphQL::Types::JSON, null: true

      def resolve(group_id:, price_nickname:, promotion_code:, payment_method_id:)
        group = ::Group.accessible_by(current_ability).find_by(id: group_id)

        if group.nil?
          raise ActiveRecord::RecordNotFound,
            I18n.t('errors.messages.resource_not_found', resource: ::Group.model_name.human)
        end

        current_ability.authorize! :attach_payment, group
        
        trial = false
        if price_nickname == "Enterprise (Trial)"
          if !group.is_trial_done
            trial = true
          end
          price_nickname = "Enterprise"
        end

        prices = Stripe::Price.list({
          active: true,
          limit: 50
        })

        price = prices.data.detect {|price| price.nickname == price_nickname}

        if payment_method_id
          group.attach_payment(payment_method_id)
        end

        sub_creator = SubscriptionCreator.new(
          group: group,
          price: price,
          trial: trial,
          promotion_code: promotion_code,
        ).call

        group = ::Group.find_by(id: group_id)

        {
          errors: sub_creator.error.present? ? [
            { 
              message: sub_creator.error,
            }
          ] : [],
          success: sub_creator.success?,
          group: group,
          stripe_subscription: sub_creator.stripe_subscription,
        }
      end
    end
  end
end
