# frozen_string_literal: true

module Resolvers
  module Rankings
    class RankingsByCountry < Resolvers::BaseResolver
      type [Types::Crawler::Rankings::RankingType], null: true
      description 'Returns all rankings of a master podcast'

      argument :group_id, ID, required: true
      argument :chart, String, required: true
      argument :country, String, required: true
      argument :category, String, required: true

      def resolve(group_id:, chart:, country:, category:)
        group = ::Group.accessible_by(current_ability).find_by(id: group_id)

        if group.nil?
          raise ActiveRecord::RecordNotFound,
          I18n.t('errors.messages.resource_not_found', resource: ::Group.model_name.human)
        end

        if group.subscription_is?("Enterprise") && group.can_use_api?("query")
          latest_ranking = ::Crawler::Ranking.where(chart: chart, country: country, category: category).last

          if latest_ranking
            return ::Crawler::Ranking.where(
              period: latest_ranking.period,
              chart: chart, 
              country: country, 
              category: category,
            ).where.not(
              podcast_id: nil
            ).group(:chart, :country, :category, :podcast_id)
              .includes(:crawler_master_podcast).order(:rank)
          end
        end

        []
      end
    end
  end
end
