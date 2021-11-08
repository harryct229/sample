# == Schema Information
#
# Table name: publishers
#
#  id          :uuid             not null, primary key
#  description :text
#  name        :string
#  website     :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
FactoryBot.define do
  factory :publisher do
    name { "MyString" }
    website { "MyString" }
    description { "MyText" }
  end
end
