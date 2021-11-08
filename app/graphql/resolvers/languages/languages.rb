# frozen_string_literal: true

module Resolvers
  module Languages
    class Languages < Resolvers::BaseResolver
      include ::SearchObject.module(:graphql)

      type Types::Languages::LanguageType.connection_type, null: false
      description 'Returns all languages'
      scope { resources }

      def resources
        ::Language.accessible_by(current_ability)
      end

      option :order_by, type: Types::ItemOrderType, with: :apply_order_by
      def allowed_order_attributes
        %w[code name created_at updated_at]
      end

      # inline input type definition for the advanced filter
      class LanguageFilterType < ::Types::BaseInputObject
        argument :OR, [self], required: false
        argument :code, String, required: false
        argument :name, String, required: false
      end
      option :filter, type: LanguageFilterType, with: :apply_filter
      def allowed_filter_attributes
        %w[code name]
      end
    end
  end
end
