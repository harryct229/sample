# frozen_string_literal: true

module Resolvers
  module Podcasts
    class Podcast < Resolvers::BaseResolver
      type Types::Podcasts::PodcastType, null: true
      description 'Returns the podcast for a requested id'

      argument :id, ID, required: true

      def resolve(id:)
        ::Podcast.accessible_by(current_ability).find_by(id: id)
      end
    end
  end
end
