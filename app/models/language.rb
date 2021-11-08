# == Schema Information
#
# Table name: languages
#
#  id         :uuid             not null, primary key
#  code       :string
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Language < ApplicationRecord
  has_many :podcast_languages
  has_many :languages, through: :podcast_languages
end
