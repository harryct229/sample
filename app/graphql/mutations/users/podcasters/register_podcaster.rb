# frozen_string_literal: true

module Mutations
  module Users
    module Podcasters
      class RegisterPodcaster < Mutations::BaseMutation
        description 'Podcaster register'
        argument :first_name, String, required: true
        argument :last_name, String, required: true
        argument :podcast_id, String, required: true
        argument :feed_url, String, required: false
        argument :is_temp, Boolean, required: true
        argument :email, String, required: true
        argument :password, String, required: true

        field :errors, [::Types::Auth::Error], null: false
        field :success, Boolean, null: false
        field :user, GraphQL::Auth.configuration.user_type.constantize, null: true

        def resolve(args)
          response = context[:response]

          if args[:is_temp]
            podcasts_attributes = [{
              state: "created",
              temporary_podcast_id: args[:podcast_id],
              feed_url: args[:feed_url],
            }]
          else
            podcasts_attributes = [{
              state: "created",
              master_podcast_id: args[:podcast_id],
              feed_url: args[:feed_url],
            }]
          end

          user = ::Podcaster.create(
            state: "email_verification_sent",
            first_name: args[:first_name],
            last_name: args[:last_name],
            email: args[:email],
            password: args[:password],
            podcasts_attributes: podcasts_attributes
          )

          {
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
      end
    end
  end
end
