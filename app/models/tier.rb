# == Schema Information
#
# Table name: tiers
#
#  id         :uuid             not null, primary key
#  name       :string
#  priority   :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Tier < ApplicationRecord
  # - VALIDATIONS
  validates :name, presence: true
  validates :name, length: { maximum: 255 }
  
  # - RELATIONS
  has_many :groups, dependent: :destroy

  # - SCOPES
  default_scope { order(:priority) }

  scope :allowed_for, -> (user) {
    where('priority >= ?', user.priority)
  }

  rails_admin do
    list do
      sort_by :priority
    end
  end
end
