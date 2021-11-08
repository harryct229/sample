# frozen_string_literal: true

module Resolvers
  module Groups
    # Resolver to return a group
    class Groups < Resolvers::BaseResolver
      include ::SearchObject.module(:graphql)

      type Types::Groups::GroupType.connection_type, null: false
      description 'Returns all group for the current group'
      scope { resources }

      def resources
        ::Group.accessible_by(current_ability)
      end

      option :order_by, type: Types::ItemOrderType, with: :apply_order_by
      def allowed_order_attributes
        %w[name company_name website created_at updated_at]
      end

      # inline input type definition for the advanced filter
      class GroupFilterType < ::Types::BaseInputObject
        argument :OR, [self], required: false
        argument :name, String, required: false
        argument :company_name, String, required: false
        argument :website, String, required: false
      end
      option :filter, type: GroupFilterType, with: :apply_filter
      def allowed_filter_attributes
        %w[name company_name website]
      end
    end
  end
end
