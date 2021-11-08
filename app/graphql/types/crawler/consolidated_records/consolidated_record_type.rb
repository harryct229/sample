# frozen_string_literal: true

module Types
  module Crawler
    module ConsolidatedRecords
      class ConsolidatedRecordType < Types::BaseModel
        field :country, String, null: true
        field :podcast_count, Integer, null: true
        field :episode_count, Integer, null: true
        field :episode_count_by_created_at, GraphQL::Types::JSON, null: true
        field :episode_count_by_duration, GraphQL::Types::JSON, null: true
        field :episode_count_by_star_rating, GraphQL::Types::JSON, null: true
        field :episode_count_by_star_rating_with_ghost, GraphQL::Types::JSON, null: true
        field :podcast_count_by_category, GraphQL::Types::JSON, null: true
        field :podcast_count_by_category_with_ghost, GraphQL::Types::JSON, null: true
        field :podcast_count_by_country, GraphQL::Types::JSON, null: true
        field :podcast_count_by_country_with_ghost, GraphQL::Types::JSON, null: true
        field :podcast_count_by_created_at, GraphQL::Types::JSON, null: true
        field :podcast_count_by_episode_count, GraphQL::Types::JSON, null: true
        field :podcast_count_by_episode_count_with_ghost, GraphQL::Types::JSON, null: true
        field :podcast_count_by_hosting, GraphQL::Types::JSON, null: true
        field :podcast_count_by_hosting_with_ghost, GraphQL::Types::JSON, null: true
        field :podcast_count_by_language, GraphQL::Types::JSON, null: true
        field :podcast_count_by_language_with_ghost, GraphQL::Types::JSON, null: true
        field :podcast_count_by_prefix, GraphQL::Types::JSON, null: true
        field :podcast_count_by_prefix_with_ghost, GraphQL::Types::JSON, null: true
        field :podcast_count_by_star_rating, GraphQL::Types::JSON, null: true
        field :podcast_count_by_star_rating_with_ghost, GraphQL::Types::JSON, null: true
        field :podcast_count_with_ghost, GraphQL::Types::JSON, null: true
        field :podcasts_by_ranking_with_ghost, GraphQL::Types::JSON, null: true
      end
    end
  end
end
