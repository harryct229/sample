# == Schema Information
#
# Table name: rankings
#
#  id               :integer          not null, primary key
#  category         :string(100)      not null
#  chart            :string(50)       not null
#  chartable_url    :string(500)
#  country          :string(50)       not null
#  name             :binary(429496729
#  period           :integer          not null
#  rank             :integer          not null
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  apple_podcast_id :string(50)
#  podcast_id       :integer
#
# Indexes
#
#  rankings_apple_p_ce6278_idx  (apple_podcast_id)
#  rankings_chart_e94295_idx    (chart,country,category)
#  rankings_chart_eab2c0_idx    (chart,podcast_id)
#  rankings_chartab_bddcfa_idx  (chartable_url)
#  rankings_period_0a7608_idx   (period)
#  rankings_period_22c8c0_idx   (period,chart,country,category)
#  rankings_period_789a7a_idx   (period,chart,country,category,podcast_id)
#  rankings_period_85c1ac_idx   (period,podcast_id)
#  rankings_period_982dbf_idx   (period,chart,podcast_id)
#  rankings_podcast_593403_idx  (podcast_id)
#
class Crawler::Ranking < CrawlerRecord
  self.table_name = "rankings"

  belongs_to :crawler_master_podcast, class_name: "Crawler::MasterPodcast", 
    foreign_key: "podcast_id", optional: true

  scope :latest_by_chart, -> (chart) {
    # latest_ranking = where(chart: chart).order(period: :desc).first
    latest_ranking = where(chart: chart).last

    if latest_ranking.nil? || latest_ranking.period == 0
      return Crawler::Ranking.none
    end

    where(chart: chart, period: latest_ranking.period).group(:chart, :country, :category, :podcast_id)
  }

  scope :in_last, -> (interval) {
    period = (Time.current - interval).strftime("%Y%m%d")
    where("period >= ?", period).group(:period, :chart, :country, :category, :podcast_id)
  }

  rails_admin do
    visible { false }
  end
end
