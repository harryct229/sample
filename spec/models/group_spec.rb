# == Schema Information
#
# Table name: groups
#
#  id                 :uuid             not null, primary key
#  company_name       :string
#  is_trial_done      :boolean          default(FALSE)
#  name               :string
#  website            :string
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  country_id         :uuid
#  created_by_id      :uuid
#  parent_group_id    :uuid
#  stripe_customer_id :string
#  tier_id            :uuid             not null
#  updated_by_id      :uuid
#
# Indexes
#
#  index_groups_on_country_id       (country_id)
#  index_groups_on_created_by_id    (created_by_id)
#  index_groups_on_parent_group_id  (parent_group_id)
#  index_groups_on_tier_id          (tier_id)
#  index_groups_on_updated_by_id    (updated_by_id)
#
# Foreign Keys
#
#  fk_rails_...  (country_id => countries.id)
#  fk_rails_...  (created_by_id => users.id)
#  fk_rails_...  (parent_group_id => groups.id)
#  fk_rails_...  (tier_id => tiers.id)
#  fk_rails_...  (updated_by_id => users.id)
#
require 'rails_helper'

RSpec.describe Group, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
