# frozen_string_literal: true

module Types
  module Crawler
    module Episodes
      class EpisodeType < Types::BaseModel
        include Rails.application.routes.url_helpers
        
        field :title, Types::CustomTypes::BinaryType, null: true
        field :audio_url, String, null: true
        field :description, Types::CustomTypes::BinaryType, null: true
        field :duration, Integer, null: true
        field :published_at, GraphQL::Types::ISO8601DateTime, null: true
        field :matchcasts_episode_analytic, GraphQL::Types::JSON, null: true

        field :has_transcripts, Boolean, null: true
        def has_transcripts
          object.transcripts.present?
        end

        field :spotify_episode_analytic, Types::SpotifyEpisodeAnalytics::SpotifyEpisodeAnalyticType, null: true
        def spotify_episode_analytic
          Loaders::AssociationLoader.for(
            object.class, 
            :spotify_episode_analytic
          ).load(object)
        end

        field :image_url, String, null: true
        def image_url
          image_episode_url(object.id)
        end
      end
    end
  end
end
