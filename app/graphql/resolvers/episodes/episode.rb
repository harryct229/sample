# frozen_string_literal: true

module Resolvers
  module Episodes
    class Episode < Resolvers::BaseResolver
      type Types::Crawler::Episodes::EpisodeType, null: true
      description 'Returns the episode for a requested id'

      argument :id, ID, required: true

      def resolve(id:)
        Crawler::Episode.find_by(id: id)
      end
    end
  end
end
