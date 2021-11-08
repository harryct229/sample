# == Schema Information
#
# Table name: podcast_social_networks
#
#  id                :uuid             not null, primary key
#  url               :string
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  podcast_id        :uuid             not null
#  social_id         :string
#  social_network_id :uuid             not null
#
# Indexes
#
#  index_podcast_social_networks_on_podcast_id         (podcast_id)
#  index_podcast_social_networks_on_social_network_id  (social_network_id)
#
# Foreign Keys
#
#  fk_rails_...  (podcast_id => podcasts.id)
#  fk_rails_...  (social_network_id => social_networks.id)
#
class PodcastSocialNetwork < ApplicationRecord
  belongs_to :podcast
  belongs_to :social_network

  validates :social_id, presence: true
  validates :url, url: { allow_nil: false, allow_blank: false }

  validates :podcast_id, uniqueness: { scope: :social_network_id }

  delegate :name, to: :social_network, allow_nil: true
end
