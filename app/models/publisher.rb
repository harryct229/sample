# == Schema Information
#
# Table name: publishers
#
#  id          :uuid             not null, primary key
#  description :text
#  name        :string
#  website     :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
class Publisher < ApplicationRecord
  has_many :podcasters, class_name: "Podcaster", foreign_key: "publisher_id", dependent: :destroy
end
