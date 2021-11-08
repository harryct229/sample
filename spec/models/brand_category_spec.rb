# == Schema Information
#
# Table name: brand_categories
#
#  id                 :uuid             not null, primary key
#  name               :string
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  parent_category_id :uuid
#
# Indexes
#
#  index_brand_categories_on_parent_category_id  (parent_category_id)
#
# Foreign Keys
#
#  fk_rails_...  (parent_category_id => brand_categories.id)
#
require 'rails_helper'

RSpec.describe BrandCategory, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
