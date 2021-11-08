# frozen_string_literal: true

module Types
  module Crawler
    module ConsolidatedRecords
      class FreeConsolidatedRecordType < Types::BaseModel
        field :podcast_count, Integer, null: true
        field :episode_count, Integer, null: true
        field :episode_count_by_created_at, GraphQL::Types::JSON, null: true
        field :podcast_count_by_category, GraphQL::Types::JSON, null: true
        field :podcast_count_by_country, GraphQL::Types::JSON, null: true
        field :podcast_count_by_created_at, GraphQL::Types::JSON, null: true
        field :podcast_count_by_episode_count, GraphQL::Types::JSON, null: true
        field :podcast_count_by_language, GraphQL::Types::JSON, null: true
      end
    end
  end
end
