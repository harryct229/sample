# frozen_string_literal: true

module Resolvers
  module BrandTypes
    class BrandTypes < Resolvers::BaseResolver
      include ::SearchObject.module(:graphql)

      type Types::BrandTypes::BrandTypeType.connection_type, null: false
      description 'Returns all brand types'
      scope { resources }

      def resources
        ::BrandType.accessible_by(current_ability)
      end

      option :order_by, type: Types::ItemOrderType, with: :apply_order_by
      def allowed_order_attributes
        %w[name created_at updated_at]
      end

      # inline input type definition for the advanced filter
      class BrandTypeFilterType < ::Types::BaseInputObject
        argument :OR, [self], required: false
        argument :name, String, required: false
      end
      option :filter, type: BrandTypeFilterType, with: :apply_filter
      def allowed_filter_attributes
        %w[name]
      end
    end
  end
end
