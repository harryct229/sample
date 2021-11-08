# frozen_string_literal: true

module Types
  module PodcastCategories
    # GraphQL type for a user
    class PodcastCategoryType < Types::BaseModel
      field :name, String, null: false
      field :parent_category_id, String, null: true
      field :parent_category, self, null: true

      field :sub_categories, [self], null: true
      def sub_categories
        Loaders::AssociationLoader.for(
          object.class, 
          :sub_categories
        ).load(object)
      end
    end
  end
end
