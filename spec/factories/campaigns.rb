# == Schema Information
#
# Table name: campaigns
#
#  id                   :uuid             not null, primary key
#  budget               :decimal(8, 2)
#  budget_distributions :hstore
#  creative_option      :integer
#  end_date             :datetime
#  name                 :string
#  objective            :integer
#  start_date           :datetime
#  state                :integer
#  website              :string
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  country_id           :uuid             not null
#  created_by_id        :uuid             not null
#  group_id             :uuid             not null
#  language_id          :uuid             not null
#
# Indexes
#
#  index_campaigns_on_country_id     (country_id)
#  index_campaigns_on_created_by_id  (created_by_id)
#  index_campaigns_on_group_id       (group_id)
#  index_campaigns_on_language_id    (language_id)
#
# Foreign Keys
#
#  fk_rails_...  (country_id => countries.id)
#  fk_rails_...  (created_by_id => users.id)
#  fk_rails_...  (group_id => groups.id)
#  fk_rails_...  (language_id => languages.id)
#
FactoryBot.define do
  factory :campaign do
    brand { nil }
    group { nil }
    start_date { "2021-09-17 11:04:22" }
    end_date { "2021-09-17 11:04:22" }
    budget { "9.99" }
    name { "MyString" }
    description { "MyText" }
    link { "MyString" }
    state { 1 }
    objective { 1 }
  end
end
