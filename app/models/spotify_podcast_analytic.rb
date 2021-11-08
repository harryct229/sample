# == Schema Information
#
# Table name: spotify_podcast_analytics
#
#  id                   :uuid             not null, primary key
#  age_distribution     :json
#  claimed_spotify_link :string
#  country_distribution :json
#  followers            :integer
#  gender_distribution  :json
#  listeners            :integer
#  starts               :integer
#  streams              :integer
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  podcast_id           :uuid             not null
#
# Indexes
#
#  index_spotify_podcast_analytics_on_podcast_id  (podcast_id)
#
# Foreign Keys
#
#  fk_rails_...  (podcast_id => podcasts.id)
#
class SpotifyPodcastAnalytic < ApplicationRecord
  belongs_to :podcast
end
