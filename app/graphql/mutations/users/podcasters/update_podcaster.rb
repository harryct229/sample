# frozen_string_literal: true

module Mutations
  module Users
    module Podcasters
      class UpdatePodcaster < Mutations::BaseMutation
        description 'Podcaster update'
        argument :first_name, String, 'First name', required: true
        argument :last_name, String, 'Last name', required: true
        argument :email, String, 'Email', required: true
        argument :phone_number, String, 'Phone number', required: true
        argument :avatar, Types::CustomTypes::FileType, 'Avatar', required: false

        field :errors, [::Types::Auth::Error], null: false
        field :success, Boolean, null: false
        field :user, GraphQL::Auth.configuration.user_type.constantize, null: true

        def resolve(args)
          user = context[:current_user]
          
          user_attributes = {
            first_name: args[:first_name],
            last_name: args[:last_name],
            email: args[:email],
            phone_number: args[:phone_number],
          }

          if args[:avatar]
            user_attributes['avatar'] = args[:avatar]
          end

          user.update(user_attributes)

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
