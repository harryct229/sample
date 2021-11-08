# == Schema Information
#
# Table name: master_podcasts
#
#  id                      :integer          not null, primary key
#  artist_name             :binary(429496729
#  country                 :string(50)
#  description             :binary(429496729
#  episode_count           :integer          not null
#  feed_url                :text(4294967295)
#  frequency               :integer
#  genres                  :text(4294967295)
#  has_rankings            :string(500)
#  hosting                 :string(1000)
#  hosting_domain          :string(1000)
#  image_url               :text(4294967295)
#  influenced_countries    :string(1000)
#  is_active               :boolean          not null
#  is_explicit             :boolean          not null
#  is_ghost                :boolean
#  is_in_platform          :boolean          not null
#  is_rss_working          :boolean
#  keywords                :text(4294967295)
#  language                :string(50)
#  last_released_at        :datetime
#  name                    :binary(429496729
#  owner_email             :string(1000)
#  prefixes                :string(1000)
#  ranking                 :float(53)
#  ranking_listener_offset :integer
#  ranking_reach_offset    :integer
#  rating_count            :integer
#  slave_count             :integer          not null
#  star_rating             :float(53)
#  synced_at               :datetime
#  tracking_analytics      :string(1000)
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#  linked_podcast_id       :integer
#
# Indexes
#
#  master_podc_is_acti_5f7d0a_idx  (is_active,is_in_platform)
#  master_podc_is_acti_6ccbc2_idx  (is_active,is_ghost)
#  master_podc_is_acti_84c4e4_idx  (is_active)
#  master_podc_is_acti_dd5699_idx  (is_active,is_rss_working)
#  master_podc_is_ghos_e3ef7f_idx  (is_ghost)
#  master_podc_updated_ea86ac_idx  (updated_at)
#


class Crawler::MasterPodcast < CrawlerRecord
  SLAVE_MODELS = [
    Crawler::ApplePodcast,
    Crawler::SoundonPodcast,
    Crawler::PodchaserPodcast,
    Crawler::CastboxPodcast,
    Crawler::PodcastIndexPodcast,
    Crawler::MatchcastsImportedPodcast,
    Crawler::MatchcastsPodcast,
    Crawler::SpotifyPodcast,
  ]

  SLAVE_MODELS_WITH_RATING = [
    Crawler::ApplePodcast,
    Crawler::PodchaserPodcast,
  ]

  RANKING_INTERVAL = 90.days

  self.table_name = "master_podcasts"

  serialize :feed_url, JSON
  serialize :language, JSON
  serialize :country, JSON
  serialize :genres, JSON
  serialize :hosting, JSON
  serialize :prefixes, JSON
  serialize :keywords, JSON
  serialize :influenced_countries, JSON
  serialize :owner_email, JSON

  has_many :podcasts, class_name: "::Podcast", foreign_key: "master_podcast_id"
  has_many :conversations, class_name: "::Conversation", foreign_key: "master_podcast_id"
  has_many :rankings, class_name: "::Crawler::Ranking", foreign_key: "podcast_id"

  def unlocked_podcast
    self.podcasts.unlocked.last
  end

  def slaves(slave_models = SLAVE_MODELS)
    slave_models.inject([]) do |_slaves, model|
      _slaves.concat(model.where(podcast_id: self.id))
    end
  end

  def slave_by_feed_url(feed_url)
    feed_url = Utils.url_no_scheme(feed_url)

    SLAVE_MODELS.each do |model|
      slaves = model.where(podcast_id: self.id)

      slaves.each do |slave|
        if slave.feed_url.include?(feed_url)
          return slave
        end
      end
    end

    nil
  end

  def episodes
    _episodes = []
    _titles = []

    self.slaves.each do |slave|
      slave.episodes.each do |episode|
        if !_titles.include?(episode.title)
          _titles << episode.title
          _episodes << episode
        end
      end
    end

    _episodes.sort_by!(&:published_at).reverse!
    _episodes
  end

  def podcast_categories
    return [] if genres.blank?

    genres.inject([]) do |_genres, genre|
      _genres.concat(PodcastCategory.where(name: genre))
    end
  end

  def languages
    return [] if language.blank?

    language.inject([]) do |_languages, language|
      _languages.concat(Language.where(code: language))
    end
  end

  def countries
    return [] if country.blank?

    country.inject([]) do |_countries, country|
      _countries.concat(Country.where(code: country))
    end
  end

  def socials
    _socials = {}

    slaves.each do |slave|
      slave.socials.each do |social, values|
        _socials[social] ||= []
        _socials[social].concat(values)
        _socials[social] = Utils.url_unique(_socials[social])
      end
    end

    _socials
  end

  def listener_count
    _listener_count = 0
    num_sources = 0

    counted = false
    slaves([Crawler::MatchcastsPodcast]).each do |slave|
      _listener_count += slave.spotify_podcast_analytic.try(:listeners) || 0
      _listener_count += slave.spotify_podcast_analytic.try(:followers) || 0

      listeners = slave.spotify_podcast_analytic.try(:listeners) || 0
      if counted == false && listeners && listeners > 0
        num_sources += 1
        counted = true
      end
    end

    counted = false
    slaves([Crawler::PodchaserPodcast]).each do |slave|
      _listener_count += slave.follower_count || 0

      if counted == false && slave.follower_count && slave.follower_count > 0
        num_sources += 1
        counted = true
      end
    end

    counted = false
    slaves([Crawler::CastboxPodcast]).each do |slave|
      _listener_count += slave.sub_count || 0

      if counted == false && slave.sub_count && slave.sub_count > 0
        num_sources += 1
        counted = true
      end
    end

    if num_sources > 0
      _listener_count /= num_sources
    end

    _listener_count += self.ranking_listener_offset || 0
    _listener_count
  end

  def reach_count
    _reach_count = 0

    slaves([Crawler::MatchcastsPodcast]).each do |slave|
      _reach_count += slave.spotify_podcast_analytic.try(:streams) || 0
      _reach_count += slave.matchcasts_podcast_analytic.try(:[], :listeners) || 0
    end

    slaves([Crawler::CastboxPodcast]).each do |slave|
      _reach_count += slave.play_count || 0
    end

    _reach_count += self.ranking_reach_offset || 0
    _reach_count
  end

  def ratings
    _ratings = {}

    slaves(SLAVE_MODELS_WITH_RATING).each do |slave|
      class_name = slave.class.name.gsub("Crawler::", "")

      if slave.rating_count and slave.rating_count > 0
        _ratings[class_name] ||= []
        _ratings[class_name] << {
          "star_rating" => slave.star_rating,
          "rating_count" => slave.rating_count,
        }
      end
    end

    _ratings
  end

  def normalized_name
    self.name.force_encoding("UTF-8")
  end

  rails_admin do
    visible { false }
    object_label_method do
      :normalized_name
    end
  end
end
