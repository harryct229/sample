# frozen_string_literal: true

module Types
  module SpotifyPodcastAnalytics
    class SpotifyPodcastAnalyticType < Types::BaseModel
      field :claimed_spotify_link, String, null: true
      field :starts, Integer, null: true
      field :listeners, Integer, null: true
      field :streams, Integer, null: true
      field :followers, Integer, null: true
      field :age_distribution, GraphQL::Types::JSON, null: true
      field :country_distribution, GraphQL::Types::JSON, null: true
      field :gender_distribution, GraphQL::Types::JSON, null: true
    end
  end
end
