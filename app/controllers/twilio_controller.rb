# frozen_string_literal: true

class TwilioController < ApplicationController
  skip_before_action :verify_authenticity_token
  skip_before_action :set_current_user
  # skip_around_action :switch_locale
  
  def webhook
    event_type = params['EventType']
    conversation_sid = params['ConversationSid']

    conversation = Conversation.find_by(conversation_sid: conversation_sid)

    if conversation
      if event_type == "onConversationStateUpdated"
        state_from = params['StateFrom']
        state_to = params['StateTo']
        reason = params['Reason']

        if reason == "TIMER" && state_to == "inactive"
          latest_message = conversation.latest_message
          conversation.participants.each do |participant|
            if latest_message.participant_sid == participant.sid
              next
            end
            if participant.last_read_message_index.present? and participant.last_read_message_index >= latest_message.index
              next
            end

            attributes = JSON.parse(participant.attributes)

            to_email = nil
            if attributes["user_type"] == "Podcaster"
              to_email = conversation.podcast.podcaster.email
              to_name = conversation.podcast.name.force_encoding("UTF-8")
              from_name = conversation.group.company_name
            elsif attributes["user_type"] == "Brand"
              to_email = conversation.group.email
              to_name = conversation.group.company_name
              from_name = conversation.podcast.name.force_encoding("UTF-8")
            end

            if to_email.present?
              SendgridUtils.send_unread_notification(
                to_email,
                to_name,
                from_name,
                latest_message.body
              )
            end
          end
        end
      end
    end

    head 200
  end
end
