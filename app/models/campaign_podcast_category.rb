# == Schema Information
#
# Table name: campaign_podcast_categories
#
#  id                  :uuid             not null, primary key
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  campaign_id         :uuid             not null
#  podcast_category_id :uuid             not null
#
# Indexes
#
#  index_campaign_podcast_categories_on_campaign_id          (campaign_id)
#  index_campaign_podcast_categories_on_podcast_category_id  (podcast_category_id)
#
# Foreign Keys
#
#  fk_rails_...  (campaign_id => campaigns.id)
#  fk_rails_...  (podcast_category_id => podcast_categories.id)
#
class CampaignPodcastCategory < ApplicationRecord
  belongs_to :podcast_category
  belongs_to :campaign
end
