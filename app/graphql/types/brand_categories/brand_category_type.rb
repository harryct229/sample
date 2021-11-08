# frozen_string_literal: true

module Types
  module BrandCategories
    # GraphQL type for a user
    class BrandCategoryType < Types::BaseModel
      field :name, String, null: false
      field :parent_category_id, ID, null: true
    end
  end
end
