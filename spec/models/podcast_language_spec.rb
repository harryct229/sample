# == Schema Information
#
# Table name: podcast_languages
#
#  id          :uuid             not null, primary key
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  language_id :uuid             not null
#  podcast_id  :uuid             not null
#
# Indexes
#
#  index_podcast_languages_on_language_id  (language_id)
#  index_podcast_languages_on_podcast_id   (podcast_id)
#
# Foreign Keys
#
#  fk_rails_...  (language_id => languages.id)
#  fk_rails_...  (podcast_id => podcasts.id)
#
require 'rails_helper'

RSpec.describe PodcastLanguage, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
