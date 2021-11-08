# == Schema Information
#
# Table name: podcasts
#
#  id                   :uuid             not null, primary key
#  additional_feed_url  :string
#  artist_name          :text
#  confirmation_sent_at :datetime
#  confirmation_token   :string
#  confirmed_at         :datetime
#  episode_count        :integer          default(0)
#  feed_url             :string
#  frequency            :integer          default(0)
#  hosting              :string
#  image_url            :string
#  is_explicit          :boolean          default(FALSE)
#  is_hosting_connected :boolean          default(FALSE), not null
#  is_spotify_connected :boolean          default(FALSE), not null
#  listener_count       :integer          default(0)
#  locked_at            :datetime
#  name                 :text
#  owner_email          :string
#  publishing_days      :text             default([]), is an Array
#  reach_count          :integer          default(0)
#  start_date           :date
#  state                :integer
#  subscriber_count     :integer          default(0)
#  unconfirmed_email    :string
#  website              :string
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  master_podcast_id    :integer
#  temporary_podcast_id :integer
#  typeform_response_id :string
#  user_id              :uuid             not null
#
# Indexes
#
#  index_podcasts_on_master_podcast_id     (master_podcast_id)
#  index_podcasts_on_temporary_podcast_id  (temporary_podcast_id)
#  index_podcasts_on_user_id               (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
require 'rails_helper'

RSpec.describe Podcast, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
