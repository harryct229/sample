# == Schema Information
#
# Table name: countries
#
#  id         :uuid             not null, primary key
#  code       :string
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Country < ApplicationRecord
  has_many :groups
  has_many :podcast_countries
  has_many :podcasts, through: :podcast_countries
end
