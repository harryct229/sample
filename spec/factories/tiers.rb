# == Schema Information
#
# Table name: tiers
#
#  id         :uuid             not null, primary key
#  name       :string
#  priority   :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
FactoryBot.define do
  factory :tier do
    name { "MyString" }
    priority { 1 }
  end
end
