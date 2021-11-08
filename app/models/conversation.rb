# == Schema Information
#
# Table name: conversations
#
#  id                :uuid             not null, primary key
#  conversation_sid  :string
#  message           :binary
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  created_by_id     :uuid
#  group_id          :uuid             not null
#  master_podcast_id :integer          not null
#  podcast_id        :uuid
#
# Indexes
#
#  index_conversations_on_created_by_id      (created_by_id)
#  index_conversations_on_group_id           (group_id)
#  index_conversations_on_master_podcast_id  (master_podcast_id)
#  index_conversations_on_podcast_id         (podcast_id)
#
# Foreign Keys
#
#  fk_rails_...  (created_by_id => users.id)
#  fk_rails_...  (group_id => groups.id)
#  fk_rails_...  (podcast_id => podcasts.id)
#
class Conversation < ApplicationRecord
  belongs_to :group
  belongs_to :crawler_master_podcast, 
    class_name: "Crawler::MasterPodcast",
    foreign_key: "master_podcast_id"
  belongs_to :created_by, 
    class_name: "User",
    foreign_key: "created_by_id", optional: true

  validates :conversation_sid, uniqueness: true
  validates :group_id, uniqueness: { scope: :master_podcast_id }

  def twilio_conversation
    return nil if conversation_sid.blank?
    client = Twilio::REST::Client.new 
    client.conversations.conversations(conversation_sid).fetch
  end

  def latest_message
    return nil if conversation_sid.blank?
    client = Twilio::REST::Client.new

    messages = client.conversations
      .conversations(conversation_sid)
      .messages
      .list(order: "desc", limit: 1)

    return messages[0]
  end

  def participants
    return nil if conversation_sid.blank?
    client = Twilio::REST::Client.new

    client.conversations
      .conversations(conversation_sid)
      .participants
      .list(limit: 5)
  end

  def podcast
    crawler_master_podcast.unlocked_podcast    
  end
end
