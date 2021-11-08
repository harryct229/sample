# == Schema Information
#
# Table name: subscriptions
#
#  id                   :uuid             not null, primary key
#  cancel_at_period_end :boolean          default(FALSE), not null
#  current_period_end   :datetime         not null
#  current_period_start :datetime         not null
#  status               :text             not null
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  external_id          :text             default(""), not null
#  group_id             :uuid             not null
#
# Indexes
#
#  index_subscriptions_on_group_id  (group_id)
#
# Foreign Keys
#
#  fk_rails_...  (group_id => groups.id)
#
require 'rails_helper'

RSpec.describe Subscription, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
