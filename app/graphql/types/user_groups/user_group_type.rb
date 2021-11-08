# frozen_string_literal: true

module Types
  module UserGroups
    class UserGroupType < Types::BaseModel
      field :user, Types::Users::UserType, null: false
      field :group, Types::Groups::GroupType, null: false
      field :role, String, null: false
    end
  end
end
