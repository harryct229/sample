# frozen_string_literal: true

module Mutations
  module Podcasts
    class DisconnectSpotify < Mutations::BaseMutation
      description 'Deletes a podcast as an owner.'
      argument :id, ID, required: true
      
      field :errors, [::Types::Auth::Error], null: false
      field :success, Boolean, null: false
      field :podcast, Types::Podcasts::PodcastType, null: true

      def resolve(id:)
        podcast = ::Podcast.accessible_by(current_ability).find_by(id: id)

        if podcast.nil?
          raise ActiveRecord::RecordNotFound,
                I18n.t('errors.messages.resource_not_found', resource: ::Podcast.model_name.human)
        end

        current_ability.authorize! :update, podcast
        podcast.update(is_spotify_connected: false)

        {
          errors: podcast.errors.messages.map do |field, messages|
            { 
              field: field.to_s.camelize(:lower),
              message: podcast.errors.full_message(field, messages.first),
            }
          end,
          success: podcast.errors.any?,
          podcast: podcast
        }
      end
    end
  end
end
