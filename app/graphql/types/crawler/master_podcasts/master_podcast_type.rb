# frozen_string_literal: true

module Types
  module Crawler
    module MasterPodcasts
      class MasterPodcastType < Types::BaseModel
        include Rails.application.routes.url_helpers
        
        field :name, Types::CustomTypes::BinaryType, null: true
        field :artist_name, Types::CustomTypes::BinaryType, null: true
        field :description, Types::CustomTypes::BinaryType, null: true
        field :feed_url, [String], null: true
        field :episode_count, Integer, null: true
        field :frequency, Integer, null: true
        field :genres, [String], null: true
        field :hosting, [String], null: true
        field :country, [String], null: true
        field :influenced_countries, [String], null: true
        field :language, [String], null: true
        field :keywords, [String], null: true
        field :prefixes, [String], null: true
        field :rating_count, Integer, null: true
        field :star_rating, Float, null: true
        field :ranking, Float, null: true
        field :ranking_listener_offset, Integer, null: true
        field :ranking_reach_offset, Integer, null: true
        field :is_explicit, Boolean, null: true
        field :is_in_platform, Boolean, null: true
        field :is_ghost, Boolean, null: true
        field :is_active, Boolean, null: true
        field :linked_podcast_id, Integer, null: true
        field :episodes, [Types::Crawler::Episodes::EpisodeType], null: true
        field :listener_count, Integer, null: true
        field :reach_count, Integer, null: true
        field :socials, GraphQL::Types::JSON, null: true
        field :ratings, GraphQL::Types::JSON, null: true

        field :image_url, String, null: true
        def image_url
          image_master_podcast_url(object.id)
        end
      end
    end
  end
end
