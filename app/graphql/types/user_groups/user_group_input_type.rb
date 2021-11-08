# frozen_string_literal: true

module Types
  module UserGroups
    # Input type for user
    class UserGroupInputType < Types::BaseInputObject
      description 'Attributes to inivte a user.'
      argument :group_id, ID, 'Group Id', required: true
      argument :role, String, 'User role in Group', required: true
    end
  end
end
