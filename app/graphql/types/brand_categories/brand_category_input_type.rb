# frozen_string_literal: true

module Types
  module BrandCategories
    class BrandCategoryInputType < Types::BaseInputObject
      description 'Attributes to create a BrandCategories.'
      argument :id, ID, 'ID', required: true
      argument :name, String, 'Name', required: false
    end
  end
end
