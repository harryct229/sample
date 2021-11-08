# frozen_string_literal: true

module Types
  module Podcasts
    class PodcastType < Types::BaseModel
      field :podcaster, Types::Users::UserType, null: false
      field :name, String, null: true
      field :artist_name, String, null: true
      field :feed_url, String, null: true
      field :additional_feed_url, String, null: true
      field :image_url, String, null: true
      field :owner_email, String, null: true
      field :hosting, String, null: true
      field :is_hosting_connected, Boolean, null: true
      field :is_spotify_connected, Boolean, null: true
      field :is_explicit, Boolean, null: true
      field :episode_count, Integer, null: true
      field :reach_count, Integer, null: true
      field :listener_count, Integer, null: true
      field :subscriber_count, Integer, null: true
      field :frequency, Integer, null: true
      field :start_date, GraphQL::Types::ISO8601DateTime, null: true
      field :publishing_days, [Integer], null: true
      field :prefix_token, String, null: true
      field :prefix_url, String, null: true
      field :state, String, null: true
      field :matchcasts_podcast_analytic, GraphQL::Types::JSON, null: true

      field :is_locked, Boolean, null: false
      def is_locked
        object.locked?
      end

      field :is_ready, Boolean, null: false
      def is_ready
        object.ready?
      end

      field :languages, [Types::Languages::LanguageType], null: true
      def languages
        Loaders::AssociationLoader.for(
          object.class, 
          :languages
        ).load(object)
      end

      field :countries, [Types::Countries::CountryType], null: true
      def countries
        Loaders::AssociationLoader.for(
          object.class, 
          :countries
        ).load(object)
      end

      field :podcast_categories, [Types::PodcastCategories::PodcastCategoryType], null: true
      def podcast_categories
        Loaders::AssociationLoader.for(
          object.class, 
          :podcast_categories
        ).load(object)
      end

      field :crawler_master_podcast, Types::Crawler::MasterPodcasts::MasterPodcastType, null: true
      def crawler_master_podcast
        Loaders::AssociationLoader.for(
          object.class, 
          :crawler_master_podcast
        ).load(object)
      end

      field :podcast_social_networks, [Types::PodcastSocialNetworks::PodcastSocialNetworkType], null: true
      def podcast_social_networks
        Loaders::AssociationLoader.for(
          object.class, 
          podcast_social_networks: :social_network
        ).load(object)
      end

      field :spotify_podcast_analytic, Types::SpotifyPodcastAnalytics::SpotifyPodcastAnalyticType, null: true
      def spotify_podcast_analytic
        Loaders::AssociationLoader.for(
          object.class, 
          :spotify_podcast_analytic
        ).load(object)
      end
    end
  end
end
