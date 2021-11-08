# == Schema Information
#
# Table name: slave_podcast_index_podcasts
#
#  id                 :integer          not null, primary key
#  artist_name        :binary(429496729 not null
#  country            :string(50)       not null
#  description        :binary(429496729
#  feed_url           :string(500)
#  frequency          :integer
#  genres             :string(1000)     not null
#  hosting            :string(100)
#  hosting_domain     :string(200)
#  image_url          :text(4294967295)
#  is_explicit        :boolean          not null
#  is_ghost           :boolean
#  is_rss_working     :boolean
#  keywords           :text(4294967295)
#  language           :string(50)       not null
#  last_released_at   :datetime
#  name               :binary(429496729 not null
#  owner_email        :string(200)
#  prefixes           :string(500)
#  raw_language       :string(50)       not null
#  synced_at          :datetime
#  tracking_analytics :string(500)
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  apple_podcast_id   :string(50)
#  podcast_id         :integer
#  podcast_index_id   :integer          not null
#
# Indexes
#
#  podcast_index_id                (podcast_index_id) UNIQUE
#  slave_podca_apple_p_f78182_idx  (apple_podcast_id)
#  slave_podca_podcast_198eea_idx  (podcast_index_id)
#  slave_podca_podcast_f67db8_idx  (podcast_id)
#
class Crawler::PodcastIndexPodcast < Crawler::SlavePodcast
  self.table_name = "slave_podcast_index_podcasts"

  rails_admin do
    visible { false }
  end
end
