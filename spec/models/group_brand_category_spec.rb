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
require 'rails_helper'

RSpec.describe GroupBrandCategory, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
