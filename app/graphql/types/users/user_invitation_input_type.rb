# frozen_string_literal: true

module Types
  module Users
    # Input type for user
    class UserInvitationInputType < Types::BaseInputObject
      description 'Attributes to inivte a user.'
      argument :email, String, 'Email of user', required: true
      argument :first_name, String, 'Firstname of user', required: true
      argument :last_name, String, 'Lastname of user', required: true
      argument :user_groups_attributes, [Types::UserGroups::UserGroupInputType], 'User Groups', required: true
    end
  end
end
