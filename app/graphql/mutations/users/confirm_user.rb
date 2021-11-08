# frozen_string_literal: true

module Mutations
  module Users
    # Accepts an invitation for a user
    class ConfirmUser < Mutations::BaseMutation
      include ::Graphql::TokenHelper

      description 'Confirm email after registration'
      argument :confirmation_token, String, required: true
      
      field :errors, [::Types::Auth::Error], null: false
      field :success, Boolean, null: false
      field :user, GraphQL::Auth.configuration.user_type.constantize, null: true
      field :authentication_token, String, null: true

      def resolve(confirmation_token:)
        response = context[:response]

        user = ::User.confirm_by_token(confirmation_token)
      
        if user.errors.empty?
          # TODO try to get from headers
          # https://zach.codes/access-response-headers-in-apollo-client/
          # generate_access_token(user, response)
          token = ::GraphQL::Auth::JwtManager.issue_with_expiration({
            user: user.id,
            issued_at: Time.now.to_i,
          })
          set_current_user(user)

          user.state = "email_verification_done"
          user.save
          
          {
            errors: [],
            success: true,
            user: user,
            authentication_token: token
          }
        else
          {
            errors: user.errors.messages.map do |field, messages|
              { 
                field: field.to_s.camelize(:lower),
                message: user.errors.full_message(field, messages.first),
              }
            end,
            success: false,
            user: nil
          }
        end
      end
    end
  end
end
