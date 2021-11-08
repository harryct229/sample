# == Schema Information
#
# Table name: languages
#
#  id         :uuid             not null, primary key
#  code       :string
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
FactoryBot.define do
  factory :language do
    code { "MyString" }
    name { "MyString" }
  end
end
