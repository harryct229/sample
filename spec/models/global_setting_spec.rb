# == Schema Information
#
# Table name: global_settings
#
#  id              :uuid             not null, primary key
#  name            :string
#  singleton_guard :integer
#  tracking_domain :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
# Indexes
#
#  index_global_settings_on_singleton_guard  (singleton_guard) UNIQUE
#
require 'rails_helper'

RSpec.describe GlobalSetting, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
