# == Schema Information
#
# Table name: brand_types
#
#  id         :uuid             not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
FactoryBot.define do
  factory :brand_type do
    name { "MyString" }
  end
end
