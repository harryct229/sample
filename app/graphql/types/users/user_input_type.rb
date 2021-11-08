# frozen_string_literal: true

module Types
  module Users
    # Input type for user
    class UserInputType < Types::BaseInputObject
      description 'Attributes to update a user.'
      argument :email, String, 'Email of user', required: false
      argument :first_name, String, 'Firstname of user', required: false
      argument :last_name, String, 'Lastname of user', required: false
      argument :password, String, 'Password of user', required: false
      argument :password_confirmation, String, 'Password confirmation', required: false
      argument :notifications, [String], 'Notifications', required: false
    end
  end
end
