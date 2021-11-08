# frozen_string_literal: true

module Resolvers
  module BrandCategories
    class BrandCategories < Resolvers::BaseResolver
      include ::SearchObject.module(:graphql)

      type Types::BrandCategories::BrandCategoryType.connection_type, null: false
      description 'Returns all brand categories'
      scope { resources }

      def resources
        ::BrandCategory.accessible_by(current_ability)
      end

      option :order_by, type: Types::ItemOrderType, with: :apply_order_by
      def allowed_order_attributes
        %w[name created_at updated_at]
      end

      # inline input type definition for the advanced filter
      class BrandCategoryFilterType < ::Types::BaseInputObject
        argument :OR, [self], required: false
        argument :name, String, required: false
        argument :parent_category_id, ID, required: false
      end
      option :filter, type: BrandCategoryFilterType, with: :apply_filter
      def allowed_filter_attributes
        %w[name parent_category_id]
      end
    end
  end
end
