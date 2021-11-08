# == Schema Information
#
# Table name: social_networks
#
#  id         :uuid             not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class SocialNetwork < ApplicationRecord
  has_many :user_social_networks, dependent: :destroy
  has_many :users, through: :user_social_networks
  has_many :podcast_social_networks, dependent: :destroy
  has_many :podcasts, through: :podcast_social_networks
end
