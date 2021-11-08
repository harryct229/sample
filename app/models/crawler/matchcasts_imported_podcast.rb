# == Schema Information
#
# Table name: slave_matchcasts_imported_podcasts
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
#  updated_fields     :text(4294967295)
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  podcast_id         :integer
#  spotify_id         :string(50)
#
# Indexes
#
#  slave_match_podcast_1d719d_idx  (podcast_id)
#  slave_match_spotify_a264ea_idx  (spotify_id)
#
class Crawler::MatchcastsImportedPodcast < Crawler::SlavePodcast
  self.table_name = "slave_matchcasts_imported_podcasts"

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
