# == Schema Information
#
# Table name: group_brand_categories
#
#  id                :uuid             not null, primary key
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  brand_category_id :uuid             not null
#  group_id          :uuid             not null
#
# Indexes
#
#  index_group_brand_categories_on_brand_category_id  (brand_category_id)
#  index_group_brand_categories_on_group_id           (group_id)
#
# Foreign Keys
#
#  fk_rails_...  (brand_category_id => brand_categories.id)
#  fk_rails_...  (group_id => groups.id)
#
class GroupBrandCategory < ApplicationRecord
  belongs_to :group
  belongs_to :brand_category

  # validates :brand_category_id, uniqueness: { scope: :group_id }
end
