# frozen_string_literal: true

module Mutations
  module Users
    module Podcasters
      class ConfirmPodcast < Mutations::BaseMutation
        include ::Graphql::TokenHelper

        description 'Confirm email after registration'
        argument :confirmation_token, String, required: true
        
        field :errors, [::Types::Auth::Error], null: false
        field :success, Boolean, null: false
        field :podcast, Types::Podcasts::PodcastType, null: true

        def resolve(confirmation_token:)
          podcast = ::Podcast.confirm_by_token(confirmation_token)
        
          if podcast.errors.empty?
            podcast.update(
              state: "rss_verification_done",
            )
            podcast.podcaster.update(
              state: "rss_verification_done"
            )

            PodcastMailer.podcast_approval_email(podcast.id).deliver_later
            
            {
              errors: [],
              success: true,
              podcast: podcast,
            }
          else
            {
              errors: podcast.errors.messages.map do |field, messages|
                { 
                  field: field.to_s.camelize(:lower),
                  message: podcast.errors.full_message(field, messages.first),
                }
              end,
              success: false,
              podcast: podcast
            }
          end
        end
      end
    end
  end
end
