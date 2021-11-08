# == Schema Information
#
# Table name: podcast_countries
#
#  id         :uuid             not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  country_id :uuid             not null
#  podcast_id :uuid             not null
#
# Indexes
#
#  index_podcast_countries_on_country_id  (country_id)
#  index_podcast_countries_on_podcast_id  (podcast_id)
#
# Foreign Keys
#
#  fk_rails_...  (country_id => countries.id)
#  fk_rails_...  (podcast_id => podcasts.id)
#
FactoryBot.define do
  factory :podcast_country do
    podcast { nil }
    country { nil }
  end
end
