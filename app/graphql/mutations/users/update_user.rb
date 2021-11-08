# frozen_string_literal: true

module Mutations
  module Users
    class UpdateUser < Mutations::BaseMutation
      description 'Updates profile'
      argument :attributes, Types::Users::UserInputType, required: true

      field :errors, [::Types::Auth::Error], null: false
      field :success, Boolean, null: false
      field :user, GraphQL::Auth.configuration.user_type.constantize, null: true

      def resolve(attributes:)
        user = context[:current_user]
        
        current_ability.authorize! :update, user
        user.attributes = attributes.to_h
        current_ability.authorize! :update, user
        user.save

        {
          errors: user.errors.messages.map do |field, messages|
            { 
              field: field.to_s.camelize(:lower),
              message: user.errors.full_message(field, messages.first),
            }
          end,
          success: user.errors.blank?,
          user: user.errors.blank? ? user : nil
        }
      end
    end
  end
end
