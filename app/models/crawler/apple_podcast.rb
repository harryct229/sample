# == Schema Information
#
# Table name: slave_apple_podcasts
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
#  primary_genre      :string(50)       not null
#  rating_count       :integer
#  raw_language       :string(50)       not null
#  star_rating        :float(53)
#  synced_at          :datetime
#  tracking_analytics :string(500)
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  apple_artist_id    :string(50)
#  apple_podcast_id   :string(50)       not null
#  podcast_id         :integer
#
# Indexes
#
#  apple_podcast_id_UNIQUE                              (apple_podcast_id) UNIQUE
#  slave_apple_apple_p_3b59f8_idx                       (apple_podcast_id)
#  slave_apple_podcast_35eef5_idx                       (podcast_id)
#  slave_apple_podcasts_apple_podcast_id_01113e77_uniq  (apple_podcast_id) UNIQUE
#
class Crawler::ApplePodcast < Crawler::SlavePodcast
  self.table_name = "slave_apple_podcasts"

  rails_admin do
    visible { false }
  end
end
