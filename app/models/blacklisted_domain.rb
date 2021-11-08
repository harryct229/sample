# == Schema Information
#
# Table name: blacklisted_domains
#
#  id         :uuid             not null, primary key
#  domain     :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_blacklisted_domains_on_domain  (domain) UNIQUE
#
class BlacklistedDomain < ApplicationRecord
end
