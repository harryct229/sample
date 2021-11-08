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
class BrandCategory < ApplicationRecord
  belongs_to :parent_category, class_name: "BrandCategory", foreign_key: "parent_category_id", optional: true

  has_many :child_categories, class_name: "BrandCategory", foreign_key: "parent_category_id"
  has_many :group_brand_categories
  has_many :groups, through: :group_brand_categories

  def root?
    parent_category_id.nil?
  end
end
