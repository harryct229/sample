# frozen_string_literal: true

module Types
  module Crawler
    module Rankings
      class RankingType < Types::BaseModel
        field :period, Integer, null: true
        field :chart, String, null: true
        field :country, String, null: true
        field :category, String, null: true
        field :rank, Integer, null: true

        field :crawler_master_podcast, Types::Crawler::MasterPodcasts::MasterPodcastType, null: true
        def crawler_master_podcast
          Loaders::AssociationLoader.for(
            object.class, 
            :crawler_master_podcast
          ).load(object)
        end
      end
    end
  end
end
