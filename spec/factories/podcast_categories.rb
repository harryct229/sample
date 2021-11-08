# == Schema Information
#
# Table name: podcast_categories
#
#  id                 :uuid             not null, primary key
#  name               :string
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  parent_category_id :uuid
#
# Indexes
#
#  index_podcast_categories_on_parent_category_id  (parent_category_id)
#
# Foreign Keys
#
#  fk_rails_...  (parent_category_id => podcast_categories.id)
#
FactoryBot.define do
  factory :podcast_category do
    name { "MyString" }
    parent_category { nil }
  end
end
