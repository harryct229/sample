# frozen_string_literal: true

module Mutations
  module Podcasts
    class ClaimSpotify < Mutations::BaseMutation
      description 'Claim Spotify account by calling Puppeteer API'
      argument :id, ID, required: true
      argument :socket_id, ID, required: true

      field :errors, [::Types::Auth::Error], null: false
      field :success, Boolean, null: false

      def resolve(args)
        user = context[:current_user]

        podcast = user.podcasts.accessible_by(current_ability).find_by(id: args[:id])

        if podcast.nil?
          raise ActiveRecord::RecordNotFound,
          I18n.t('errors.messages.resource_not_found', resource: ::Podcast.model_name.human)
        end

        uri = URI("#{ENV['SCRAPER_URL']}/api/Podcasts/spotify_claim_podcast")
        data = { 
          user_id: user.id,
          podcast_id: podcast.id,
          socket_id: args[:socket_id]
        }.to_json

        res = Net::HTTP.post(uri, data, "Content-Type" => "application/json")

        {
          errors: [],
          success: res.kind_of?(Net::HTTPSuccess),
        }
      end
    end
  end
end
