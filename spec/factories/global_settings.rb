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
FactoryBot.define do
  factory :global_setting do
    name { "MyString" }
    tracking_domain { "MyString" }
  end
end
