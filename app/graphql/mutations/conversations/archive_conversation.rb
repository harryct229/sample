# frozen_string_literal: true

module Mutations
  module Conversations
    class ArchiveConversation < Mutations::BaseMutation
      description 'Create conversation'
      argument :conversation_sid, ID, required: true
      
      field :errors, [::Types::Auth::Error], null: false
      field :success, Boolean, null: false
      field :conversation_sid, ID, null: false

      def resolve(group_id:, conversation_sid:)
        ActiveRecord::Base.transaction do
          @user = context[:current_user]
          @conversation = Conversation.find_by(conversation_sid: conversation_sid)

          if @conversation.nil?
            raise ActiveRecord::RecordNotFound,
              I18n.t('errors.messages.resource_not_found', resource: ::Conversation.model_name.human)
          end

          current_ability.authorize! :update, @conversation

          @client = Twilio::REST::Client.new 
          @twilio_conversation = @client.conversations.conversations(conversation_sid).fetch
          attributes = JSON.parse(@twilio_conversation.attributes)

          if attributes["is_disabled"] == 1
            @client.conversations.conversations(conversation_sid).delete
            @conversation.destroy
          else
            if attributes["is_archived"] == 0
              attributes["is_archived"] = 1
              @client.conversations
                .conversations(@conversation.conversation_sid)
                .update(attributes: attributes.to_json)
            end
          end
        end

        {
          errors: [],
          success: true,
          conversation_sid: conversation_sid,
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
          conversation_sid: nil,
        }
      end
    end
  end
end
