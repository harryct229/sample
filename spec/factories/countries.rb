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
FactoryBot.define do
  factory :country do
    code { "MyString" }
    name { "MyString" }
  end
end
