# == Schema Information
#
# Table name: user_social_networks
#
#  id                :uuid             not null, primary key
#  profile_url       :string
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  social_network_id :uuid             not null
#  user_id           :uuid             not null
#
# Indexes
#
#  index_user_social_networks_on_social_network_id  (social_network_id)
#  index_user_social_networks_on_user_id            (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (social_network_id => social_networks.id)
#  fk_rails_...  (user_id => users.id)
#
class UserSocialNetwork < ApplicationRecord
  belongs_to :user
  belongs_to :social_network
end
