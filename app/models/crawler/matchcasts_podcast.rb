# == Schema Information
#
# Table name: slave_matchcasts_podcasts
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
#  is_active          :boolean          not null
#  is_explicit        :boolean          not null
#  is_ghost           :boolean
#  is_rss_working     :boolean
#  keywords           :text(4294967295)
#  language           :string(50)       not null
#  last_released_at   :datetime
#  name               :binary(429496729 not null
#  owner_email        :string(200)
#  prefixes           :string(500)
#  social_ids         :text(4294967295)
#  synced_at          :datetime
#  tracking_analytics :string(500)
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  matchcasts_id      :string(100)      not null
#  podcast_id         :integer
#  spotify_id         :string(50)
#
# Indexes
#
#  slave_match_matchca_ee67f7_idx                         (matchcasts_id)
#  slave_match_podcast_acf70a_idx                         (podcast_id)
#  slave_match_spotify_e77ad8_idx                         (spotify_id)
#  slave_matchcasts_podcasts_matchcasts_id_fc250420_uniq  (matchcasts_id) UNIQUE
#
class Crawler::MatchcastsPodcast < Crawler::SlavePodcast
  self.table_name = "slave_matchcasts_podcasts"

  serialize :social_ids, JSON

  belongs_to :podcast, class_name: "::Podcast", foreign_key: "matchcasts_id", optional: true

  delegate :spotify_podcast_analytic, :matchcasts_podcast_analytic, to: :podcast, allow_nil: true

  def socials
    _socials = {}

    if podcast
      podcast.podcast_social_networks.includes(:social_network).each do |psn|
        social = psn.name.downcase
        _socials[social] ||= []
        _socials[social] << psn.social_id
        _socials[social] = Utils.url_unique(_socials[social])
      end

      if podcast.website
        _socials["website"] = [podcast.website]
      end
    end

    if self.spotify_id
      _socials["spotify"] = [self.spotify_id]
      _socials["spotify"] = Utils.url_unique(_socials["spotify"])
    end

    _socials
  end

  rails_admin do
    object_label_method do
      :normalized_name
    end
  end
end
