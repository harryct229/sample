# frozen_string_literal: true

module Mutations
  module Users
    module Brands
      class SkipIntro < Mutations::BaseMutation
        description 'Skip intro'
        
        field :errors, [::Types::Auth::Error], null: false
        field :success, Boolean, null: false
        field :user, GraphQL::Auth.configuration.user_type.constantize, null: true

        def resolve()
          user = context[:current_user]

          user.update(state: "intro_done")

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
end
