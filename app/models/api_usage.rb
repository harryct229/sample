# == Schema Information
#
# Table name: api_usages
#
#  id               :uuid             not null, primary key
#  email_quota      :integer
#  query_quota      :integer
#  used_email_quota :integer
#  used_query_quota :integer
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  subscription_id  :uuid             not null
#
# Indexes
#
#  index_api_usages_on_subscription_id  (subscription_id)
#
# Foreign Keys
#
#  fk_rails_...  (subscription_id => subscriptions.id)
#
class ApiUsage < ApplicationRecord
  belongs_to :subscription
end
