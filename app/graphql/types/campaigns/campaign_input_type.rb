# frozen_string_literal: true

module Types
  module Campaigns
    class CampaignInputType < Types::BaseInputObject
      argument :budget, Float, required: true
      argument :budget_distributions, GraphQL::Types::JSON, required: true
      argument :country, String, required: true
      argument :language, String, required: true
      argument :creative_option, String, required: true
      argument :name, String, required: true
      argument :description, String, required: true
      argument :website, String, required: true
      argument :objective, String, required: true
      argument :start_date, GraphQL::Types::ISO8601DateTime, required: true
      argument :end_date, GraphQL::Types::ISO8601DateTime, required: true
      argument :podcast_categories, [Types::PodcastCategories::PodcastCategoryInputType], required: true
      argument :sponsorship_logo, Types::CustomTypes::FileType, required: true
      argument :script, String, required: false
      argument :audio, Types::CustomTypes::FileType, required: false
    end
  end
end
