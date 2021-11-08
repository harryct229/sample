# frozen_string_literal: true

module Mutations
  module Groups
    # Updates an existing group as an admin.
    class UpdateGroup < Mutations::BaseMutation
      description 'Updates an existing group as an admin.'
      argument :id, ID, required: true
      argument :attributes, Types::Groups::GroupInputType, required: true
      payload_type Types::Groups::GroupType

      def resolve(id:, attributes:)
        group = ::Group.accessible_by(current_ability).find_by(id: id)
        if group.nil?
          raise ActiveRecord::RecordNotFound,
            I18n.t('errors.messages.resource_not_found', resource: ::Group.model_name.human)
        end

        current_ability.authorize! :update, group
        group.attributes = attributes.to_h
        current_ability.authorize! :update, group
        return group if group.save!
      end
    end
  end
end
