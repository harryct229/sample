# frozen_string_literal: true

module Resolvers
  module Rankings
    class RankingsByMasterPodcast < Resolvers::BaseResolver
      type [Types::Crawler::Rankings::RankingType], null: true
      description 'Returns all rankings of a master podcast'

      argument :group_id, ID, required: true
      argument :master_podcast_id, ID, required: true
      argument :chart, String, required: true

      def resolve(group_id:, master_podcast_id:, chart:)
        group = ::Group.accessible_by(current_ability).find_by(id: group_id)

        if group.nil?
          raise ActiveRecord::RecordNotFound,
          I18n.t('errors.messages.resource_not_found', resource: ::Group.model_name.human)
        end

        if group.can_use_api?("query")
          master_podcast = ::Crawler::MasterPodcast.find_by(id: master_podcast_id)

          if master_podcast.nil?
            raise ActiveRecord::RecordNotFound,
              I18n.t('errors.messages.resource_not_found', resource: "Podcast")
          end

          return master_podcast.rankings.latest_by_chart(chart)
        end

        []
      end
    end
  end
end
