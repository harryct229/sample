# frozen_string_literal: true

module Resolvers
  module Conversations
    class Conversation < Resolvers::BaseResolver
      type Types::Conversations::ConversationType, null: true
      description 'Returns conversation'

      argument :group_id, ID, required: false
      argument :master_podcast_id, ID, required: true

      def resolve(group_id: nil, master_podcast_id:)
        user = context[:current_user]

        conversation = nil
        if user.type?("Brand")
          conversation = ::Conversation.accessible_by(current_ability).find_by(group_id: group_id, master_podcast_id: master_podcast_id)
        elsif user.type?("Podcaster")
          conversation = ::Conversation.accessible_by(current_ability).find_by(master_podcast_id: master_podcast_id)
        end

        conversation
      end
    end
  end
end
