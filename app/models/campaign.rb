# == Schema Information
#
# Table name: campaigns
#
#  id                   :uuid             not null, primary key
#  budget               :decimal(8, 2)
#  budget_distributions :hstore
#  creative_option      :integer
#  end_date             :datetime
#  name                 :string
#  objective            :integer
#  start_date           :datetime
#  state                :integer
#  website              :string
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  country_id           :uuid             not null
#  created_by_id        :uuid             not null
#  group_id             :uuid             not null
#  language_id          :uuid             not null
#
# Indexes
#
#  index_campaigns_on_country_id     (country_id)
#  index_campaigns_on_created_by_id  (created_by_id)
#  index_campaigns_on_group_id       (group_id)
#  index_campaigns_on_language_id    (language_id)
#
# Foreign Keys
#
#  fk_rails_...  (country_id => countries.id)
#  fk_rails_...  (created_by_id => users.id)
#  fk_rails_...  (group_id => groups.id)
#  fk_rails_...  (language_id => languages.id)
#
class Campaign < ApplicationRecord
  MIN_BUDGET = 5000

  enum creative_option: { 
    host_read_ad: 1,
    audio_ad: 2,
  }

  enum objective: { 
    "Brand Awareness" => 1,
    "Engagement" => 2,
    "Reach" => 3,
    "Lead Generation" => 4,
  }

  enum state: { 
    created: 1,
    matched: 2,
    running: 3,
    paused: 4,
    cancelled: 5,
    done: 9,
  }

  belongs_to :group
  belongs_to :language
  belongs_to :country
  belongs_to :created_by, class_name: "User", foreign_key: "created_by_id", optional: true

  has_many :campaign_podcast_categories, dependent: :destroy
  has_many :podcast_categories, through: :campaign_podcast_categories

  has_rich_text :script
  has_rich_text :description
  has_one_attached :sponsorship_logo
  has_one_attached :audio

  accepts_nested_attributes_for :campaign_podcast_categories, allow_destroy: true

  validates :name, :budget, :website, :start_date, :end_date, :budget_distributions, presence: true
  validates :budget, numericality: { greater_than_or_equal_to: MIN_BUDGET }
  validates :website, url: { allow_nil: true, allow_blank: true }
  validates :sponsorship_logo, attached: true, content_type: ['image/png', 'image/jpeg', 'image/gif'], size: {less_than: 5.megabytes}
  validates :audio, attached: false, content_type: ['image/png', 'image/jpeg', 'image/gif'], size: {less_than: 10.megabytes}

  validate :start_date_after_today
  validate :end_date_after_start_date

  scope :created_by, -> (user) { where(created_by_id: user.id) }

  private

  def start_date_after_today
    return if start_date.blank?

    if start_date < Time.current
      errors.add(:start_date, "must be after the today")
    end
  end

  def end_date_after_start_date
    return if end_date.blank? || start_date.blank?

    if end_date < start_date
      errors.add(:end_date, "must be after the start date")
    end
  end
end
