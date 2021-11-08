# == Schema Information
#
# Table name: consolidated_records
#
#  id                                        :integer          not null, primary key
#  country                                   :string(50)
#  episode_count                             :integer          not null
#  episode_count_by_created_at               :text(4294967295) not null
#  episode_count_by_duration                 :text(4294967295) not null
#  episode_count_by_star_rating              :text(4294967295) not null
#  episode_count_by_star_rating_with_ghost   :text(4294967295)
#  podcast_count                             :integer          not null
#  podcast_count_by_category                 :text(4294967295) not null
#  podcast_count_by_category_with_ghost      :text(4294967295)
#  podcast_count_by_country                  :text(4294967295) not null
#  podcast_count_by_country_with_ghost       :text(4294967295)
#  podcast_count_by_created_at               :text(4294967295) not null
#  podcast_count_by_episode_count            :text(4294967295) not null
#  podcast_count_by_episode_count_with_ghost :text(4294967295)
#  podcast_count_by_hosting                  :text(4294967295) not null
#  podcast_count_by_hosting_with_ghost       :text(4294967295)
#  podcast_count_by_language                 :text(4294967295) not null
#  podcast_count_by_language_with_ghost      :text(4294967295)
#  podcast_count_by_prefix                   :text(4294967295) not null
#  podcast_count_by_prefix_with_ghost        :text(4294967295)
#  podcast_count_by_star_rating              :text(4294967295) not null
#  podcast_count_by_star_rating_with_ghost   :text(4294967295)
#  podcast_count_with_ghost                  :text(4294967295)
#  podcasts_by_ranking_with_ghost            :text(4294967295)
#  created_at                                :datetime         not null
#  updated_at                                :datetime         not null
#
# Indexes
#
#  consolidate_country_b9cd74_idx  (country)
#
class Crawler::ConsolidatedRecord < CrawlerRecord
  self.table_name = "consolidated_records"

  scope :recent, -> { order("created_at DESC") }
  scope :by_country, -> (country) { where(country: country) }

  serialize :episode_count_by_created_at, JSON
  serialize :episode_count_by_duration, JSON
  serialize :episode_count_by_star_rating, JSON
  serialize :episode_count_by_star_rating_with_ghost, JSON
  serialize :podcast_count_by_category, JSON
  serialize :podcast_count_by_category_with_ghost, JSON
  serialize :podcast_count_by_country, JSON
  serialize :podcast_count_by_country_with_ghost, JSON
  serialize :podcast_count_by_created_at, JSON
  serialize :podcast_count_by_episode_count, JSON
  serialize :podcast_count_by_episode_count_with_ghost, JSON
  serialize :podcast_count_by_hosting, JSON
  serialize :podcast_count_by_hosting_with_ghost, JSON
  serialize :podcast_count_by_language, JSON
  serialize :podcast_count_by_language_with_ghost, JSON
  serialize :podcast_count_by_prefix, JSON
  serialize :podcast_count_by_prefix_with_ghost, JSON
  serialize :podcast_count_by_star_rating, JSON
  serialize :podcast_count_by_star_rating_with_ghost, JSON
  serialize :podcast_count_with_ghost, JSON
  serialize :podcasts_by_ranking_with_ghost, JSON

  def mask_for(group)
    if !group.subscription_is?("Enterprise")
      self.assign_attributes(
        podcast_count_by_hosting: {"Anchor":0,"Acast":0,"Other":0,"iVoox":0,"Soundcloud":0,"Libsyn":0,"Spreaker":0,"Buzzsprout":0,"Transistor":0,"Megaphone":0,"Podbean":0,"Simplecast":0,"Audioboom":0,"Blubrry":0,"ART19":0,"Omnystudio":0,"Captivate":0,"Pinecast":0,"Fireside":0,"Podiant":0,"Ausha":0},
        podcast_count_by_hosting_with_ghost: {"active":{},"inactive":{}},
        podcast_count_by_prefix: {"Podtrac":0,"Podcorn":0,"Chartable":0,"Megaphone":0,"Backtrack":0},
        podcast_count_by_prefix_with_ghost: {"active":{},"inactive":{}},
        podcasts_by_ranking_with_ghost: {"active":{},"inactive":{}},
      )
      if !group.subscription_is?("Professional")
        self.assign_attributes(
          podcast_count_by_episode_count: {},
          podcast_count_by_episode_count_with_ghost: {"active":{},"inactive":{}},
          podcast_count_by_star_rating: {},
          podcast_count_by_star_rating_with_ghost: {"active":{},"inactive":{}},
          episode_count_by_duration: {},
          episode_count_by_star_rating: {},
          episode_count_by_star_rating_with_ghost: {"active":{},"inactive":{}},
        )

        if !group.subscription_is?("Starter")
          self.assign_attributes(
            podcast_count: 2000000,
            episode_count: 80000000,
            podcast_count_by_created_at: {"2020-04":0,"2020-05":0,"2020-06":0,"2020-07":0,"2020-08":0,"2020-09":1251796,"2020-10":1347966,"2020-11":1445126,"2020-12":1529387,"2021-01":1547963,"2021-02":2306170,"2021-03":2307859},
            episode_count_by_created_at: {"2020-04":0,"2020-05":0,"2020-06":0,"2020-07":0,"2020-08":0,"2020-09":31098913,"2020-10":34465474,"2020-11":37645577,"2020-12":41724676,"2021-01":44572904,"2021-02":58958562,"2021-03":62356545},
            podcast_count_with_ghost: {"active":10000,"inactive":10000,"test":10000},
            podcast_count_by_category: {"Comedy":0,"Music":0,"TV & Film":0,"Careers":0,"Business":0,"Self-Improvement":0,"Education":0,"Baseball":0,"Sports":0,"Fashion & Beauty":0,"Arts":0,"Design":0,"Film Interviews":0,"Leisure":0,"Christianity":0,"Religion & Spirituality":0,"Science":0,"How To":0,"Technology":0,"Comedy Interviews":0,"News":0,"News Commentary":0,"Improv":0,"Music Commentary":0,"Stories for Kids":0,"Kids & Family":0,"Courses":0,"Society & Culture":0},
            podcast_count_by_category_with_ghost: {"active":{"Comedy":0,"Music":0,"TV & Film":0,"Careers":0,"Business":0,"Self-Improvement":0,"Education":0,"Baseball":0,"Sports":0,"Fashion & Beauty":0,"Arts":0,"Design":0,"Film Interviews":0,"Leisure":0,"Christianity":0,"Religion & Spirituality":0,"Science":0,"How To":0,"Technology":0,"Comedy Interviews":0,"News":0,"News Commentary":0,"Improv":0,"Music Commentary":0,"Stories for Kids":0,"Kids & Family":0,"Courses":0,"Society & Culture":0},"inactive":{"Comedy":0,"Music":0,"TV & Film":0,"Careers":0,"Business":0,"Self-Improvement":0,"Education":0,"Baseball":0,"Sports":0,"Fashion & Beauty":0,"Arts":0,"Design":0,"Film Interviews":0,"Leisure":0,"Christianity":0,"Religion & Spirituality":0,"Science":0,"How To":0,"Technology":0,"Comedy Interviews":0,"News":0,"News Commentary":0,"Improv":0,"Music Commentary":0,"Stories for Kids":0,"Kids & Family":0,"Courses":0,"Society & Culture":0}},
            podcast_count_by_language: {"en":0,"ko":0,"zh":0,"ar":0,"yue":0,"ja":0,"fr":0,"pt":0,"id":0},
            podcast_count_by_language_with_ghost: {"active":{"en":0,"ko":0,"zh":0,"ar":0,"yue":0,"ja":0,"fr":0,"pt":0,"id":0},"inactive":{"en":0,"ko":0,"zh":0,"ar":0,"yue":0,"ja":0,"fr":0,"pt":0,"id":0}},
            podcast_count_by_country: {"US":0,"KR":0,"CN":0,"SA":0,"TW":0,"HK":0,"JP":0,"FR":0,"CA":0,"PT":0,"ID":0,"AM":0,"ES":0,"DE":0,"IN":0},
            podcast_count_by_country_with_ghost: {"active":{"US":0,"KR":0,"CN":0,"SA":0,"TW":0,"HK":0,"JP":0,"FR":0,"CA":0,"PT":0,"ID":0,"AM":0,"ES":0,"DE":0,"IN":0},"inactive":{"US":0,"KR":0,"CN":0,"SA":0,"TW":0,"HK":0,"JP":0,"FR":0,"CA":0,"PT":0,"ID":0,"AM":0,"ES":0,"DE":0,"IN":0}},
          )
        end
      end
    end

    return self
  end

  rails_admin do
    visible { false }
  end
end
