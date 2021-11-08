# == Schema Information
#
# Table name: slave_podchaser_podcasts
#
#  id                  :integer          not null, primary key
#  artist_name         :binary(429496729 not null
#  country             :string(50)       not null
#  description         :binary(429496729
#  external_ids        :text(4294967295)
#  feed_url            :string(500)
#  follower_count      :integer          not null
#  frequency           :integer
#  genres              :string(1000)     not null
#  hosting             :string(100)
#  hosting_domain      :string(200)
#  image_url           :text(4294967295)
#  is_explicit         :boolean          not null
#  is_ghost            :boolean
#  is_rss_working      :boolean
#  keywords            :text(4294967295)
#  language            :string(50)       not null
#  last_released_at    :datetime
#  name                :binary(429496729 not null
#  owner_email         :string(200)
#  prefixes            :string(500)
#  rating_count        :integer          not null
#  raw_language        :string(50)       not null
#  review_count        :integer          not null
#  social_links        :text(4294967295)
#  star_rating         :float(53)
#  synced_at           :datetime
#  total_hashtag_count :integer          not null
#  tracking_analytics  :string(500)
#  website             :string(500)
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  apple_podcast_id    :string(50)
#  podcast_id          :integer
#  podchaser_id        :integer          not null
#  spotify_id          :string(50)
#
# Indexes
#
#  podchaser_id                    (podchaser_id) UNIQUE
#  slave_podch_apple_p_10a174_idx  (apple_podcast_id)
#  slave_podch_podcast_9e348d_idx  (podcast_id)
#  slave_podch_podchas_55527d_idx  (podchaser_id)
#  slave_podch_spotify_0b1d90_idx  (spotify_id)
#
class Crawler::PodchaserPodcast < Crawler::SlavePodcast
  self.table_name = "slave_podchaser_podcasts"

  serialize :social_links, JSON

  def socials
    _socials = {}

    if social_links
      SocialNetwork.pluck(:name).map(&:downcase).each do |social|
        if social_links[social]
          _socials[social] ||= []
          _socials[social] << social_links[social]
          _socials[social] = Utils.url_unique(_socials[social])
        end
      end

    end
    
    if self.website
      _socials["website"] = [self.website]
    end

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
