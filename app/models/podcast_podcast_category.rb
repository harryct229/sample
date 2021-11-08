# == Schema Information
#
# Table name: podcast_podcast_categories
#
#  id                  :uuid             not null, primary key
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  podcast_category_id :uuid             not null
#  podcast_id          :uuid             not null
#
# Indexes
#
#  index_podcast_podcast_categories_on_podcast_category_id  (podcast_category_id)
#  index_podcast_podcast_categories_on_podcast_id           (podcast_id)
#
# Foreign Keys
#
#  fk_rails_...  (podcast_category_id => podcast_categories.id)
#  fk_rails_...  (podcast_id => podcasts.id)
#
class PodcastPodcastCategory < ApplicationRecord
  belongs_to :podcast
  belongs_to :podcast_category

  # validates :podcast_category_id, uniqueness: { scope: :podcast_id }
end
