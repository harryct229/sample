# == Schema Information
#
# Table name: brand_types
#
#  id         :uuid             not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
require 'rails_helper'

RSpec.describe BrandType, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
