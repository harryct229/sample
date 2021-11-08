# == Schema Information
#
# Table name: social_networks
#
#  id         :uuid             not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
FactoryBot.define do
  factory :social_network do
    name { "MyString" }
  end
end
