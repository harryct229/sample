# frozen_string_literal: true

module Mutations
  module Users
    module Brands
      class RegisterBrand < Mutations::BaseMutation
        description 'Brand register'
        argument :first_name, String, required: true
        argument :last_name, String, required: true
        argument :website, String, required: true
        argument :company_name, String, required: true
        argument :email, String, required: true
        argument :password, String, required: true

        field :errors, [::Types::Auth::Error], null: false
        field :success, Boolean, null: false
        field :user, GraphQL::Auth.configuration.user_type.constantize, null: true

        def resolve(args)
          response = context[:response]

          tier = ::Tier.find_by(priority: 2)

          begin
            ActiveRecord::Base.transaction do
              user = ::Brand.create!(
                state: "email_verification_sent",
                first_name: args[:first_name],
                last_name: args[:last_name],
                email: args[:email],
                password: args[:password],
              )

              User.current_user = user

              user.user_groups.create!(
                role: "admin",
                group_attributes: {
                  skip_priority_limits: true,
                  tier: tier,
                  name: args[:company_name],
                  company_name: args[:company_name],
                  website: args[:website],
                }
              )

              return {
                errors: user.errors.messages.map do |field, messages|
                  { 
                    field: field.to_s.camelize(:lower),
                    message: user.errors.full_message(field, messages.first),
                  }
                end,
                success: user.persisted?,
                user: user.persisted? ? user : nil
              }
            end
          rescue ActiveRecord::RecordInvalid => exception
            return {
              errors: [
                { 
                  message: exception.message,
                }
              ],
              success: false,
              user: nil
            }
          end
        end
      end
    end
  end
end
