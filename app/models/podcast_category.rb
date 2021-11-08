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
class PodcastCategory < ApplicationRecord
  belongs_to :parent_category, class_name: "PodcastCategory", foreign_key: "parent_category_id", optional: true

  has_many :sub_categories, class_name: "PodcastCategory", foreign_key: "parent_category_id"
  has_many :podcast_podcast_categories
  has_many :podcasts, through: :podcast_podcast_categories

  scope :only_root, -> {
    where(parent_category_id: nil)
  }

  def root?
    parent_category_id.nil?
  end
end
