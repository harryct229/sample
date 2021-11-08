# frozen_string_literal: true

module Mutations
  module Podcasts
    class AddPodcast < Mutations::BaseMutation
      description 'Add Podcast'
      argument :podcast_id, String, required: true
      argument :feed_url, String, required: false
      argument :is_temp, Boolean, required: true

      field :errors, [::Types::Auth::Error], null: false
      field :success, Boolean, null: false
      field :podcast, Types::Podcasts::PodcastType, null: true

      def resolve(args)
        user = context[:current_user]

        if args[:is_temp]
          podcast = Podcast.create(
            state: "created",
            feed_url: args[:feed_url],
            temporary_podcast_id: args[:podcast_id],
            user_id: user.id,
          )
        else
          podcast = Podcast.create(
            state: "created",
            feed_url: args[:feed_url],
            master_podcast_id: args[:podcast_id],
            user_id: user.id,
          )
        end

        {
          errors: podcast.errors.messages.map do |field, messages|
            { 
              field: field.to_s.camelize(:lower),
              message: podcast.errors.full_message(field, messages.first),
            }
          end,
          success: podcast.persisted?,
          podcast: podcast.persisted? ? podcast : nil
        }
      end
    end
  end
end
