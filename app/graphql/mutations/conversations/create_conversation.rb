# frozen_string_literal: true

module Mutations
  module Conversations
    class CreateConversation < Mutations::BaseMutation
      description 'Create conversation'
      argument :group_id, ID, required: true
      argument :master_podcast_id, ID, required: true
      argument :message, String, required: false
      
      field :errors, [::Types::Auth::Error], null: false
      field :success, Boolean, null: false
      field :conversation_sid, ID, null: true

      def resolve(group_id:, master_podcast_id:, message:)
        ActiveRecord::Base.transaction do
          @user = context[:current_user]
          @group = ::Group.accessible_by(current_ability).find_by(id: group_id)
          @crawler_master_podcast = ::Crawler::MasterPodcast.find_by(id: master_podcast_id)

          if @group.nil?
            raise ActiveRecord::RecordNotFound,
              I18n.t('errors.messages.resource_not_found', resource: ::Group.model_name.human)
          end

          if @crawler_master_podcast.nil?
            raise ActiveRecord::RecordNotFound,
              I18n.t('errors.messages.resource_not_found', resource: "Podcast")
          end

          current_ability.authorize! :create_conversation, @group

          @client = Twilio::REST::Client.new 
          @podcast = @crawler_master_podcast.unlocked_podcast
          @conversation = Conversation.find_by(group_id: group_id, master_podcast_id: master_podcast_id)
          @twilio_conversation = nil

          if @podcast
            if @group.can_use_api?("email")
              if @conversation
                if @conversation.sid.present?
                  reconnect_conversation
                else
                  create_twilio_conversation
                  update_conversation
                end
              else
                create_twilio_conversation
                create_conversation
              end
            else
              return {
                errors: [
                  { 
                    message: "You reach limit of your tier",
                  }
                ],
                success: false,
                conversation_sid: nil,
              }
            end
          else
            all_masked = true
            @crawler_master_podcast.owner_email.each do |email|
              if Utils.valid_email?(email) && !Utils.masked_email?(email)
                SendgridUtils.send_brand_message(email, @crawler_master_podcast, @group, message)
                all_masked = false
              end
            end

            if all_masked
              SendgridUtils.send_brand_message(ENV['RSS_EMAIL'], @crawler_master_podcast, @group, message)
            end

            create_conversation(message)
          end
        end

        {
          errors: [],
          success: true,
          conversation_sid: @conversation.conversation_sid,
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

      private
      def create_twilio_conversation
        attributes = {
          master_podcast_id: @crawler_master_podcast.id,
          podcast_id: @podcast.id,
          group_id: @group.id,
          podcaster_id: @podcast.user_id,
          is_archived: 0,
        }

        @twilio_conversation = @client.conversations
          .conversations
          .create(
             friendly_name: "#{@group.company_name}__x__#{@crawler_master_podcast.name.force_encoding("UTF-8")}",
             unique_name: "#{@group.id}__x__#{@crawler_master_podcast.id}",
             timers_inactive: "PT5M",
             attributes: attributes.to_json
           )

        attributes = {
          user_type: "Brand",
          group_id: @group.id,
        }

        @client.conversations.conversations(@twilio_conversation.sid).participants.create(
          identity: @user.conversation_identity(@group.id),
          attributes: attributes.to_json
        )

        attributes = {
          user_type: "Podcaster",
          master_podcast_id: @crawler_master_podcast.id,
          podcast_id: @podcast.id,
          podcaster_id: @podcast.user_id,
        }

        @client.conversations.conversations(@twilio_conversation.sid).participants.create(
          identity: @podcast.podcaster.conversation_identity(@group.id),
          attributes: attributes.to_json
        )

        @client.conversations.conversations(@twilio_conversation.sid).messages.create(
          author: nil, 
          body: "This conversation is now connected!"
        )
      end

      def create_conversation(message = nil)
        @conversation = Conversation.new(
          conversation_sid: @twilio_conversation.try(:sid),
          master_podcast_id: @crawler_master_podcast.id,
          group_id: @group.id,
          created_by_id: @user.id,
          message: message,
        )
        @group.use_api!("email")
        @conversation.save!
      end

      def update_conversation
        @conversation.conversation_sid = @twilio_conversation.sid
        @conversation.save!
      end

      def reconnect_conversation
        @twilio_conversation = @client.conversations.conversations(@conversation.conversation_sid).fetch
        attributes = JSON.parse(@twilio_conversation.attributes)
        if attributes["is_archived"] == 1
          attributes["is_archived"] = 0
          @client.conversations
            .conversations(@conversation.conversation_sid)
            .update(
              attributes: attributes.to_json
            )
          @client.conversations.conversations(@conversation.conversation_sid).messages.create(
            author: nil, 
            body: "You are reconnected!"
          )
          @group.use_api!("email")
        end
      end
    end
  end
end
