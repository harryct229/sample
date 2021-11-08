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
require 'rails_helper'

RSpec.describe UserGroup, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
