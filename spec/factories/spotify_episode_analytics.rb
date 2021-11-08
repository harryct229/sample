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
FactoryBot.define do
  factory :spotify_episode_analytic do
    episode_id { 1 }
    gender_distribution { "" }
    country_distribution { "" }
    age_distribution { "" }
    starts { 1 }
    listeners { 1 }
    streams { 1 }
  end
end
