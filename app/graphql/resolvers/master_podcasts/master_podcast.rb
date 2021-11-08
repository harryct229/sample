# frozen_string_literal: true

module Resolvers
  module MasterPodcasts
    class MasterPodcast < Resolvers::BaseResolver
      type Types::Crawler::MasterPodcasts::MasterPodcastType, null: true
      description 'Returns the master podcast for a requested id'

      argument :id, ID, required: true
      argument :group_id, ID, required: true

      def resolve(id:, group_id:)
        group = ::Group.accessible_by(current_ability).find_by(id: group_id)

        if group.nil?
          raise ActiveRecord::RecordNotFound,
          I18n.t('errors.messages.resource_not_found', resource: ::Group.model_name.human)
        end

        if group.can_use_api?("query")
          master_podcast = Crawler::MasterPodcast.find_by(id: id)

          if master_podcast.present?
            group.use_api!("query")
          end

          return master_podcast
        end

        nil
      end
    end
  end
end
