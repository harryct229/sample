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
FactoryBot.define do
  factory :conversation do
    brand { nil }
    podcaster { nil }
    podcast { nil }
    conversation_sid { "MyString" }
    message { "" }
  end
end
