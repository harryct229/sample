# frozen_string_literal: true

module Types
  module PodcastSocialNetworks
    class PodcastSocialNetworkType < Types::BaseModel
      # field :podcast, Types::Podcasts::PodcastType, null: true
      # field :social_network, Types::SocialNetworks::SocialNetworkType, null: true
      field :url, String, null: true
      field :social_id, String, null: true

      field :social_name, String, null: false
      def social_name
        object.social_network.name
      end
    end
  end
end
