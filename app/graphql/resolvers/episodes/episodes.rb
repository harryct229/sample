# frozen_string_literal: true

module Resolvers
  module Episodes
    class Episodes < Resolvers::BaseResolver
      type [Types::Crawler::Episodes::EpisodeType], null: false
      description 'Returns all episode of a master podcast'

      argument :master_podcast_id, ID, required: true
      argument :group_id, ID, required: true

      def resolve(master_podcast_id:, group_id:)
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
          
          return master_podcast.episodes
        end

        []
      end
    end
  end
end
