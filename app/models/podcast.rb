# == Schema Information
#
# Table name: podcasts
#
#  id                   :uuid             not null, primary key
#  additional_feed_url  :string
#  artist_name          :text
#  confirmation_sent_at :datetime
#  confirmation_token   :string
#  confirmed_at         :datetime
#  episode_count        :integer          default(0)
#  feed_url             :string
#  frequency            :integer          default(0)
#  hosting              :string
#  image_url            :string
#  is_explicit          :boolean          default(FALSE)
#  is_hosting_connected :boolean          default(FALSE), not null
#  is_spotify_connected :boolean          default(FALSE), not null
#  listener_count       :integer          default(0)
#  locked_at            :datetime
#  name                 :text
#  owner_email          :string
#  publishing_days      :text             default([]), is an Array
#  reach_count          :integer          default(0)
#  start_date           :date
#  state                :integer
#  subscriber_count     :integer          default(0)
#  unconfirmed_email    :string
#  website              :string
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  master_podcast_id    :integer
#  temporary_podcast_id :integer
#  typeform_response_id :string
#  user_id              :uuid             not null
#
# Indexes
#
#  index_podcasts_on_master_podcast_id     (master_podcast_id)
#  index_podcasts_on_temporary_podcast_id  (temporary_podcast_id)
#  index_podcasts_on_user_id               (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
class Podcast < ApplicationRecord
  include Lockable
  include MatchcastsPodcastAnalytic
  
  attr_accessor :is_new

  devise :confirmable, :async

  enum state: { 
    created: 1102,
    rss_verification_sent: 1103,
    rss_verification_done: 1104,
    detail_updated: 1105,
    ready: 1108,
  }

  belongs_to :podcaster, class_name: "Podcaster", foreign_key: "user_id", inverse_of: :podcasts
  belongs_to :crawler_master_podcast, class_name: "Crawler::MasterPodcast",
    foreign_key: "master_podcast_id", optional: true
  belongs_to :crawler_temporary_podcast, class_name: "Crawler::TemporaryPodcast",
    foreign_key: "temporary_podcast_id", optional: true

  has_many :podcast_podcast_categories, dependent: :destroy
  has_many :podcast_categories, through: :podcast_podcast_categories
  has_many :podcast_countries, dependent: :destroy
  has_many :countries, through: :podcast_countries
  has_many :podcast_languages, dependent: :destroy
  has_many :languages, through: :podcast_languages
  has_many :podcast_social_networks, dependent: :destroy
  has_many :social_networks, through: :podcast_social_networks
  
  has_one :spotify_podcast_analytic, dependent: :destroy
  has_one :crawler_matchcasts_podcast, class_name: "Crawler::MatchcastsPodcast", foreign_key: "matchcasts_id"

  accepts_nested_attributes_for :podcast_podcast_categories, allow_destroy: true
  accepts_nested_attributes_for :podcast_countries, allow_destroy: true
  accepts_nested_attributes_for :podcast_languages, allow_destroy: true
  accepts_nested_attributes_for :podcast_social_networks, allow_destroy: true

  # - ALIAS
  alias_attribute :email, :owner_email

  # - DELEGATE
  delegate :prefix_token, :prefix_url, to: :podcaster, allow_nil: true
  delegate :episodes, to: :crawler_master_podcast, allow_nil: true

  # - VALIDATIONS
  validates :frequency, presence: true, if: :is_new
  validates :publishing_days, presence: true, if: :is_new
  validates :start_date, presence: true, if: :is_new

  validates :reach_count, presence: true, unless: :is_new
  validates :listener_count, presence: true, unless: :is_new
  validates :subscriber_count, presence: true, unless: :is_new

  # - CALLBACKS
  before_create :sync_with_crawler_podcast
  before_update :reserve_state
  after_save :sync_with_matchcasts_podcast

  def crawler_podcast
    has_master? ? crawler_master_podcast : crawler_temporary_podcast
  end

  def crawler_slave_podcast
    if has_master?
      if self.feed_url.present?
        slave = crawler_master_podcast.slave_by_feed_url(self.feed_url)
        return slave
      end
    else
      return crawler_temporary_podcast
    end
  end

  def send_verification_email
    # TODO: Use sidekiq in production
    self.send_confirmation_instructions
  end  

  def will_save_change_to_email?
    false
  end     
  
  def refresh
    uri = URI(ENV["CRAWLER_API"])
    slave = crawler_slave_podcast
    query = "
      mutation{    
        refreshPodcast(refreshData: {
          id: #{slave.id},
          podcastType: \"#{slave.class.name.demodulize}\"
        }){
          refresh
        }
      }
    "

    res = Net::HTTP.post(uri, { query: query }.to_json, 
      "Content-Type" => "application/json")

    if res.kind_of?(Net::HTTPSuccess)
      podcast.is_hosting_connected = self.hosting_connected?
      podcast.save!

      JSON.parse(res.body).try("[]", "data")
        .try("[]", "refreshPodcast").try("[]", "refresh")
    else
      false
    end
  end

  protected

  def confirmation_required?
    (self.created? || self.rss_verification_sent?) &&
    self.owner_email != podcaster.email
  end

  private

  def has_master?
    master_podcast_id.present?
  end

  def sync_with_crawler_podcast
    self.name = crawler_podcast.name.force_encoding("UTF-8")
    self.artist_name = crawler_podcast.artist_name.force_encoding("UTF-8")
    self.image_url = crawler_podcast.image_url
    self.languages = crawler_podcast.languages
    self.countries = crawler_podcast.countries
    self.is_explicit = crawler_podcast.is_explicit
    self.frequency = crawler_podcast.frequency
    self.podcast_categories = crawler_podcast.podcast_categories
    self.episode_count = crawler_podcast.episode_count

    if has_master?
      if self.feed_url.present?
        slave = crawler_master_podcast.slave_by_feed_url(self.feed_url)
        self.owner_email = slave.owner_email
        self.image_url = slave.image_url
        self.hosting = slave.hosting
        # self.episode_count = slave.episode_count
      end
    else
      self.feed_url = crawler_temporary_podcast.feed_url
      self.hosting = crawler_temporary_podcast.hosting
      self.owner_email = crawler_temporary_podcast.owner_email
      self.episode_count = crawler_temporary_podcast.episode_count
    end

    true
  end

  def sync_with_matchcasts_podcast
    if Rails.env.production?
      matchcasts_podcast = Crawler::MatchcastsPodcast.find_or_initialize_by(matchcasts_id: self.id)

      matchcasts_podcast.feed_url = self.feed_url || ""
      matchcasts_podcast.image_url = self.image_url || ""
      matchcasts_podcast.name = self.name.strip.encode("UTF-8") || ""
      matchcasts_podcast.artist_name = self.artist_name.strip.encode("UTF-8") || ""
      matchcasts_podcast.owner_email = self.owner_email || ""
      matchcasts_podcast.is_explicit = self.is_explicit || false

      genres = self.podcast_categories.pluck(:name)
      genres = genres.first(10)
      genres = genres.join(",")
      matchcasts_podcast.genres = genres || ""

      matchcasts_podcast.language = self.languages.pluck(:code).join(",") || ""
      matchcasts_podcast.country = self.countries.pluck(:code).join(",") || ""
      matchcasts_podcast.is_active = true
      matchcasts_podcast.hosting_domain = ""

      matchcasts_podcast.save
    end
  end

  def hosting_connected?
    if crawler_slave_podcast
      return crawler_slave_podcast.podcast_prefixes.include?(ENV["MATCHCASTS_PREFIX"]) &&
        crawler_slave_podcast.episodes.first.audio_url.include?(prefix_token)
    end

    false
  end

  def reserve_state
    current_state = self.class.states[state].to_i
    legacy_state = self.class.states[state_was].to_i

    self.state = [legacy_state, current_state].max
  end
end
