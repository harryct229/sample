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
require 'rails_helper'

RSpec.describe Tier, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
