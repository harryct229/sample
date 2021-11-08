# frozen_string_literal: true

module Types
  # Loads queries into schema
  # include other queries and resolvers here
  class QueryType < BaseObject
    # Master
    field :countries, resolver: Resolvers::Countries::Countries
    field :languages, resolver: Resolvers::Languages::Languages
    field :podcast_categories, resolver: Resolvers::PodcastCategories::PodcastCategories
    field :brand_categories, resolver: Resolvers::BrandCategories::BrandCategories
    field :brand_types, resolver: Resolvers::BrandTypes::BrandTypes

    # User
    field :me, resolver: Resolvers::Users::Me
    field :users, resolver: Resolvers::Users::Users
    field :user, resolver: Resolvers::Users::User

    # Group
    field :groups, resolver: Resolvers::Groups::Groups
    field :group, resolver: Resolvers::Groups::Group
    field :upcoming_invoice, resolver: Resolvers::Groups::UpcomingInvoice

    # Promotion code
    field :promotion_code, resolver: Resolvers::PromotionCodes::PromotionCode

    # Podcast
    field :podcast, resolver: Resolvers::Podcasts::Podcast

    # Crawler
    field :master_podcast, resolver: Resolvers::MasterPodcasts::MasterPodcast
    field :episodes, resolver: Resolvers::Episodes::Episodes
    field :episode, resolver: Resolvers::Episodes::Episode
    field :consolidated_record, resolver: Resolvers::ConsolidatedRecords::ConsolidatedRecord
    field :free_consolidated_record, resolver: Resolvers::ConsolidatedRecords::FreeConsolidatedRecord
    field :rankings_by_country, resolver: Resolvers::Rankings::RankingsByCountry
    field :rankings_by_master_podcast, resolver: Resolvers::Rankings::RankingsByMasterPodcast

    # Conversation
    field :conversation, resolver: Resolvers::Conversations::Conversation

    # Campaigns
    field :campaigns, resolver: Resolvers::Campaigns::Campaigns
  end
end
