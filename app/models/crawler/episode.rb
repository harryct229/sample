# == Schema Information
#
# Table name: episodes
#
#  id           :integer          not null, primary key
#  audio_url    :text(4294967295) not null
#  description  :binary(429496729 not null
#  duration     :bigint
#  guid         :string(500)      not null
#  image_url    :text(4294967295)
#  podcast_type :string(50)
#  published_at :datetime
#  title        :binary(429496729 not null
#  transcripts  :text(4294967295)
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  podcast_id   :integer          not null
#
# Indexes
#
#  episodes_podcast_020be2_idx  (podcast_id,guid,podcast_type)
#  episodes_podcast_f17a47_idx  (podcast_id,podcast_type)
#

class Crawler::Episode < CrawlerRecord
  include MatchcastsEpisodeAnalytic

  self.table_name = "episodes"

  scope :order_by_published_at, -> { order(published_at: :desc)  }

  serialize :transcripts, JSON

  has_one :spotify_episode_analytic, class_name: "::SpotifyEpisodeAnalytic", foreign_key: "episode_id"

  rails_admin do
    visible { false }
  end
end
