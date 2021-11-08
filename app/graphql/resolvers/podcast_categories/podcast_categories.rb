# frozen_string_literal: true

module Resolvers
  module PodcastCategories
    class PodcastCategories < Resolvers::BaseResolver
      include ::SearchObject.module(:graphql)

      type Types::PodcastCategories::PodcastCategoryType.connection_type, null: false
      description 'Returns all Podcast categories'
      scope { resources }

      def resources
        ::PodcastCategory.accessible_by(current_ability)
      end

      option :order_by, type: Types::ItemOrderType, with: :apply_order_by
      def allowed_order_attributes
        %w[name created_at updated_at]
      end

      # inline input type definition for the advanced filter
      class PodcastCategoryFilterType < ::Types::BaseInputObject
        argument :OR, [self], required: false
        argument :name, String, required: false
        argument :parent_category_id, ID, required: false
      end
      option :filter, type: PodcastCategoryFilterType, with: :apply_filter
      def allowed_filter_attributes
        %w[name parent_category_id]
      end

      option(:only_root, type: Boolean) { |scope, value| scope.only_root if value }
    end
  end
end
