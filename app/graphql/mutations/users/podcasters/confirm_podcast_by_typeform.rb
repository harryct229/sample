# frozen_string_literal: true

module Mutations
  module Users
    module Podcasters
      class ConfirmPodcastByTypeform < Mutations::BaseMutation
        description 'Confirm email after submitting Typeform'
        argument :podcast_id, ID, required: true
        argument :typeform_response_id, ID, required: true
        
        field :errors, [::Types::Auth::Error], null: false
        field :success, Boolean, null: false
        field :podcast, Types::Podcasts::PodcastType, null: true

        def resolve(podcast_id:, typeform_response_id:)
          podcast = ::Podcast.accessible_by(current_ability).find_by(id: podcast_id)
          
          podcast.update(
            state: "rss_verification_done",
            typeform_response_id: typeform_response_id
          )
          podcast.podcaster.update(
            state: "rss_verification_done"
          )

          PodcastMailer.podcast_approval_email(podcast.id).deliver_later
          
          {
            errors: podcast.errors.messages.map do |field, messages|
              { 
                field: field.to_s.camelize(:lower),
                message: podcast.errors.full_message(field, messages.first),
              }
            end,
            success: podcast.errors.empty?,
            podcast: podcast,
          }
        end
      end
    end
  end
end
