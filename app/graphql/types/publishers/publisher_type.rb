# frozen_string_literal: true

module Types
  module Publishers
    class PublisherType < Types::BaseModel
      field :name, String, null: false
      field :description, String, null: true
      field :website, String, null: true

      field :podcasts, [Types::Podcasts::PodcastType], null: true
      def podcasts
        Loaders::AssociationLoader.for(
          object.class, 
          :podcasts
        ).load(object)
      end
    end
  end
end
