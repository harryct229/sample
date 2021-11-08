module MatchcastsEpisodeAnalytic
  extend ActiveSupport::Concern

  def matchcasts_episode_analytic
    filters = Utils.generate_filters()

    rollups = Rollup.where_dimensions(episode_id: self.id).multi_series("Episode listener")
    unique_rollups = Rollup.where_dimensions(episode_id: self.id).multi_series("Episode unique listener")

    analytics = {
      listeners: {},
      unique_listeners: {},
      countries: {},
      regions: {},
      cities: {},
      operating_systems: {},
      device_types: {},
      browsers: {},
    }

    rollups.each do |rollup|
      filters.each do |filter, periods|
        analytics[:listeners][filter] ||= 0
        analytics[:countries][filter] ||= {}
        analytics[:regions][filter] ||= {}
        analytics[:cities][filter] ||= {}
        analytics[:operating_systems][filter] ||= {}
        analytics[:device_types][filter] ||= {}
        analytics[:browsers][filter] ||= {}

        rollup[:data].each do |date, count|
          _date = date.beginning_of_day 
          if _date.beginning_of_day >= periods[0] and _date < periods[1]
            analytics[:listeners][filter] += count.to_i
            analytics[:countries][filter][rollup[:dimensions]["country_code"]] ||= 0
            analytics[:countries][filter][rollup[:dimensions]["country_code"]] += count.to_i
            analytics[:regions][filter][rollup[:dimensions]["region"]] ||= 0
            analytics[:regions][filter][rollup[:dimensions]["region"]] += count.to_i
            analytics[:cities][filter][rollup[:dimensions]["city"]] ||= 0
            analytics[:cities][filter][rollup[:dimensions]["city"]] += count.to_i
            analytics[:operating_systems][filter][rollup[:dimensions]["os"]] ||= 0
            analytics[:operating_systems][filter][rollup[:dimensions]["os"]] += count.to_i
            analytics[:device_types][filter][rollup[:dimensions]["device_type"]] ||= 0
            analytics[:device_types][filter][rollup[:dimensions]["device_type"]] += count.to_i
            analytics[:browsers][filter][rollup[:dimensions]["browser"]] ||= 0
            analytics[:browsers][filter][rollup[:dimensions]["browser"]] += count.to_i
          end
        end
      end
    end

    unique_rollups.each do |rollup|
      filters.each do |filter, periods|
        analytics[:unique_listeners][filter] ||= 0

        rollup[:data].each do |date, count|
          _date = date.beginning_of_day 
          if _date.beginning_of_day >= periods[0] and _date < periods[1]
            if count > 0
              analytics[:unique_listeners][filter] += 1
            end
          end
        end
      end
    end

    analytics
  end
end
