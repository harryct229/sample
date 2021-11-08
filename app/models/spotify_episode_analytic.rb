# == Schema Information
#
# Table name: spotify_episode_analytics
#
#  id                   :uuid             not null, primary key
#  age_distribution     :json
#  claimed_spotify_link :string
#  country_distribution :json
#  gender_distribution  :json
#  listeners            :integer
#  starts               :integer
#  streams              :integer
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  episode_id           :integer
#
# Indexes
#
#  index_spotify_episode_analytics_on_episode_id  (episode_id)
#
class SpotifyEpisodeAnalytic < ApplicationRecord
end
