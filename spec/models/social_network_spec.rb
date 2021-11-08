# == Schema Information
#
# Table name: social_networks
#
#  id         :uuid             not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
require 'rails_helper'

RSpec.describe SocialNetwork, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
