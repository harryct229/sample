# frozen_string_literal: true

module Mutations
  module UserGroups
    # Updates the role for an user as an admin.
    class UpdateUserGroupRole < Mutations::BaseMutation
      description 'Updates the role for an user in a group.'
      argument :id, ID, required: true
      argument :role, String, required: true, description: '"user" or "admin"'
      payload_type Boolean

      def resolve(id:, role:)
        user_group = ::UserGroup.accessible_by(current_ability).find_by(id: id)
        if user_group.nil?
          raise ActiveRecord::RecordNotFound,
                I18n.t('errors.messages.resource_not_found', resource: ::UserGroup.model_name.human)
        end

        if %w[admin user].include?(role)
          user_group.role = role
          current_ability.authorize! :update, user_group
          user_group.save!
          return true
        end

        false
      end
    end
  end
end
