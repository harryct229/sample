# frozen_string_literal: true

module Mutations
  module Users
    module Podcasters
      class OnboardPodcasterStepThree < Mutations::BaseMutation
        description 'Podcaster onboard Step 3'
        argument :id, ID, required: true
        argument :is_new, Boolean, 'New podcast?', required: true
        argument :listener_count, Integer, 'Listener count', required: false
        argument :reach_count, Integer, 'Reach count', required: false
        argument :subscriber_count, Integer, 'Subscriber count', required: false
        argument :frequency, Types::CustomTypes::SelectInputType, 'Frequency', required: false
        argument :start_date, GraphQL::Types::ISO8601DateTime, 'Start date', required: false
        argument :publishing_days, [Types::CustomTypes::SelectInputType], 'Publishing days', required: false
        argument :podcast_social_networks, [Types::PodcastSocialNetworks::PodcastSocialNetworkInputType], 'Social accounts', required: false

        field :errors, [::Types::Auth::Error], null: false
        field :success, Boolean, null: false
        field :user, GraphQL::Auth.configuration.user_type.constantize, null: true

        def resolve(args)
          user = context[:current_user]

          podcast = user.podcasts.accessible_by(current_ability).find_by(id: args[:id])

          if podcast.nil?
            raise ActiveRecord::RecordNotFound,
            I18n.t('errors.messages.resource_not_found', resource: ::Podcast.model_name.human)
          end

          podcast_social_networks_attributes = args[:podcast_social_networks].inject([]) do |items, item|
            social_network = SocialNetwork.find_by(name: item.social_name)
            if social_network
              if item.id
                if item.url.present?
                  items << {
                    id: item.id,
                    social_network_id: social_network.id,
                    url: item.url,
                    social_id: item.social_id,
                  }
                else
                  items << {
                    id: item.id,
                    _destroy: true,
                  }
                end
              else
                if item.url.present?
                  items << {
                    social_network_id: social_network.id,
                    url: item.url,
                    social_id: item.social_id,
                  }
                end
              end
            end

            items
          end

          if args[:is_new]
            podcast_attributes = {
              id: podcast.id,
              state: "detail_updated",
              is_hosting_connected: podcast.send(:hosting_connected?),
              start_date: args[:start_date],
              frequency: args[:frequency].id,
              publishing_days: args[:publishing_days].map(&:id),
              podcast_social_networks_attributes: podcast_social_networks_attributes,
            }
          else
            podcast_attributes = {
              id: podcast.id,
              state: "detail_updated",
              is_hosting_connected: podcast.send(:hosting_connected?),
              listener_count: args[:listener_count],
              reach_count: args[:reach_count],
              subscriber_count: args[:subscriber_count],
              podcast_social_networks_attributes: podcast_social_networks_attributes,
            }
          end

          user.update(
            state: "detail_updated",
            podcasts_attributes: [podcast_attributes],
          )

          {
            errors: user.errors.messages.map do |field, messages|
              { 
                field: field.to_s.camelize(:lower),
                message: user.errors.full_message(field, messages.first),
              }
            end,
            success: user.errors.blank?,
            user: user.errors.blank? ? user : nil
          }
        end
      end
    end
  end
end
