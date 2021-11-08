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
FactoryBot.define do
  factory :podcast_social_network do
    
  end
end
