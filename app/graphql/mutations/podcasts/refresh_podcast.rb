# frozen_string_literal: true

module Mutations
  module Podcasts
    class RefreshPodcast < Mutations::BaseMutation
      description 'Refresh podcast by calling Crawler API'
      argument :id, ID, required: true

      field :errors, [::Types::Auth::Error], null: false
      field :success, Boolean, null: false
      field :podcast, Types::Podcasts::PodcastType, null: true

      def resolve(args)
        user = context[:current_user]

        podcast = user.podcasts.accessible_by(current_ability).find_by(id: args[:id])

        if podcast.nil?
          raise ActiveRecord::RecordNotFound,
          I18n.t('errors.messages.resource_not_found', resource: ::Podcast.model_name.human)
        end

        success = podcast.refresh
        podcast = ::Podcast.find(podcast.id)

        {
          errors: [],
          success: success,
          podcast: podcast
        }
      end
    end
  end
end
