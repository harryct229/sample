# == Schema Information
#
# Table name: user_groups
#
#  id         :uuid             not null, primary key
#  role       :integer          default("user"), not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  group_id   :uuid             not null
#  user_id    :uuid             not null
#
# Indexes
#
#  index_user_groups_on_group_id  (group_id)
#  index_user_groups_on_user_id   (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (group_id => groups.id)
#  fk_rails_...  (user_id => users.id)
#
class UserGroup < ApplicationRecord
  enum role: { user: 0, admin: 1 }

  belongs_to :user
  belongs_to :group

  validates :user_id, uniqueness: { scope: :group_id }

  accepts_nested_attributes_for :group
end
