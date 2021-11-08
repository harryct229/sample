# == Schema Information
#
# Table name: slave_temporary_podcasts
#
#  id                 :integer          not null, primary key
#  artist_name        :binary(429496729 not null
#  country            :string(50)       not null
#  description        :binary(429496729
#  episode_count      :integer          not null
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
#  synced_at          :datetime
#  tracking_analytics :string(500)
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#
class Crawler::TemporaryPodcast < CrawlerRecord
  self.table_name = "slave_temporary_podcasts"

  has_many :podcasts, class_name: "::Podcast", 
    foreign_key: "temporary_podcast_id"

  def episodes
    Crawler::Episode.where("podcast_type = ? AND podcast_id = ?", self.class.name.demodulize, self.id)
  end

  def podcast_categories
    return [] if genres.blank?

    genres.split(",").inject([]) do |_genres, genre|
      _genres.concat(PodcastCategory.where(name: genre))
    end
  end

  def languages
    return [] if language.blank?

    language.split(",").inject([]) do |_languages, language|
      _languages.concat(Language.where(code: language))
    end
  end

  def countries
    return [] if country.blank?

    country.split(",").inject([]) do |_countries, country|
      _countries.concat(Country.where(code: country))
    end
  end

  def podcast_prefixes
    return [] if prefixes.blank?
    prefixes.split(",")
  end

  rails_admin do
    visible { false }
  end
end
