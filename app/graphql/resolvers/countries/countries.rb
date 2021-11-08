# frozen_string_literal: true

module Resolvers
  module Countries
    class Countries < Resolvers::BaseResolver
      include ::SearchObject.module(:graphql)

      type Types::Countries::CountryType.connection_type, null: false
      description 'Returns all countries'
      scope { resources }

      def resources
        ::Country.accessible_by(current_ability)
      end

      option :order_by, type: Types::ItemOrderType, with: :apply_order_by
      def allowed_order_attributes
        %w[code name created_at updated_at]
      end

      # inline input type definition for the advanced filter
      class CountryFilterType < ::Types::BaseInputObject
        argument :OR, [self], required: false
        argument :code, String, required: false
        argument :name, String, required: false
      end
      option :filter, type: CountryFilterType, with: :apply_filter
      def allowed_filter_attributes
        %w[code name]
      end
    end
  end
end
