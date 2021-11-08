# == Schema Information
#
# Table name: slave_spotify_podcasts
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
#  prefixes           :string(500)
#  raw_language       :string(50)       not null
#  synced_at          :datetime
#  tracking_analytics :string(500)
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  podcast_id         :integer
#  spotify_id         :string(50)       not null
#
# Indexes
#
#  slave_spoti_podcast_7a97d2_idx                   (podcast_id)
#  slave_spoti_spotify_329f9e_idx                   (spotify_id)
#  slave_spotify_podcasts_spotify_id_54f61f94_uniq  (spotify_id) UNIQUE
#
class Crawler::SpotifyPodcast < Crawler::SlavePodcast
  self.table_name = "slave_spotify_podcasts"

  def socials
    _socials = {}

    if self.spotify_id
      _socials["spotify"] = [self.spotify_id]
      _socials["spotify"] = Utils.url_unique(_socials["spotify"])
    end

    _socials
  end

  rails_admin do
    visible { false }
  end
end
