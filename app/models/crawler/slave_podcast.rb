class Crawler::SlavePodcast < CrawlerRecord
  belongs_to :master_podcast, class_name: "Crawler::MasterPodcast", 
    foreign_key: "podcast_id", optional: true

  def episodes
    Crawler::Episode.where("podcast_type = ? AND podcast_id = ?", self.class.name.demodulize, self.id)
      .order_by_published_at
  end

  def podcast_categories
    return [] if genres.blank?

    genres.split(",").inject([]) do |_genres, genre|
      _genres.concat(PodcastCategory.where(name: genre))
    end
  end

  def podcast_prefixes
    return [] if prefixes.blank?
    prefixes.split(",")
  end

  def episode_count
    self.episodes.count
  end

  def socials
    {}
  end

  def normalized_name
    self.name.force_encoding("UTF-8")
  end
end
