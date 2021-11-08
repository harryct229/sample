# frozen_string_literal: true

module Types
  module PodcastCategories
    class PodcastCategoryInputType < Types::BaseInputObject
      description 'Attributes to create a PodcastCategories.'
      argument :id, ID, 'ID', required: true
      argument :name, String, 'Name', required: false
    end
  end
end
