# frozen_string_literal: true

module Types
  module Conversations
    class ConversationType < Types::BaseModel
      field :message, Types::CustomTypes::BinaryType, null: true
      field :conversation_sid, String, null: true
      field :podcast, Types::Podcasts::PodcastType, null: true

      field :twilio_conversation, GraphQL::Types::JSON, null: true
      def twilio_conversation
        {
          sid: object.twilio_conversation.sid,
          attributes: JSON.parse(object.twilio_conversation.attributes),
        }
      end

      field :group, Types::Groups::GroupType, null: true
      def group
        Loaders::AssociationLoader.for(
          object.class, 
          :group
        ).load(object)
      end

      field :crawler_master_podcast, Types::Crawler::MasterPodcasts::MasterPodcastType, null: true
      def crawler_master_podcast
        Loaders::AssociationLoader.for(
          object.class, 
          :crawler_master_podcast
        ).load(object)
      end

      field :created_by, Types::Users::UserType, null: true
      def created_by
        Loaders::AssociationLoader.for(
          object.class, 
          :created_by
        ).load(object)
      end
    end
  end
end
