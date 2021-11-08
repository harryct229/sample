# frozen_string_literal: true

module Mutations
  module Conversations
    class GenerateConversationToken < Mutations::BaseMutation
      description 'Generate conversation token'
      argument :group_id, ID, required: false
      
      field :errors, [::Types::Auth::Error], null: false
      field :success, Boolean, null: false
      field :token, String, null: true
      field :identity, String, null: true

      def resolve(group_id: nil)
        user = context[:current_user]

        if user.type?("Brand")
          group = ::Group.accessible_by(current_ability).find_by(id: group_id)

          if group.nil?
            raise ActiveRecord::RecordNotFound,
              I18n.t('errors.messages.resource_not_found', resource: ::Group.model_name.human)
          end
        end

        # current_ability.authorize! :attach_payment, group

        # Create Chat grant for our token
        grant = Twilio::JWT::AccessToken::ChatGrant.new
        grant.service_sid = ENV["TWILIO_SERVICE_SID"]
        identity = user.conversation_identity(group_id)

        token = Twilio::JWT::AccessToken.new(
          ENV['TWILIO_ACCOUNT_SID'],
          ENV['TWILIO_API_KEY'],
          ENV['TWILIO_API_SECRET'],
          [grant],
          identity: identity,
          ttl: 4 * 3600,
        )

        {
          errors: [],
          success: true,
          token: token.to_jwt,
          identity: identity,
        }
      rescue Exception => e
        puts [e.message, *e.backtrace].join($/)
        
        {
          errors: [
            { 
              message: e.message,
            }
          ],
          success: false,
          token: nil,
          identity: nil,
        }
      end
    end
  end
end
