# frozen_string_literal: true

module Types
  # Loads mutations into schema
  # Include ither mutations here
  class MutationType < Types::BaseObject
    implements ::Types::GraphqlAuth

    # User
    field :update_user, mutation: Mutations::Users::UpdateUser
    field :update_user_role, mutation: Mutations::Users::UpdateUserRole
    field :delete_user, mutation: Mutations::Users::DeleteUser
    field :invite_user, mutation: Mutations::Users::InviteUser
    field :accept_invite, mutation: Mutations::Users::AcceptInvite
    field :confirm_user, mutation: Mutations::Users::ConfirmUser

    # Podcaster
    field :register_podcaster, mutation: Mutations::Users::Podcasters::RegisterPodcaster
    field :onboard_podcaster_step_one, mutation: Mutations::Users::Podcasters::OnboardPodcasterStepOne
    field :confirm_podcast, mutation: Mutations::Users::Podcasters::ConfirmPodcast
    field :confirm_podcast_by_typeform, mutation: Mutations::Users::Podcasters::ConfirmPodcastByTypeform
    field :onboard_podcaster_step_three, mutation: Mutations::Users::Podcasters::OnboardPodcasterStepThree
    field :onboard_podcaster_step_four, mutation: Mutations::Users::Podcasters::OnboardPodcasterStepFour
    field :resend_podcast_confirmation, mutation: Mutations::Users::Podcasters::ResendPodcastConfirmation
    field :update_podcaster, mutation: Mutations::Users::Podcasters::UpdatePodcaster

    # Podcast
    field :add_podcast, mutation: Mutations::Podcasts::AddPodcast
    field :delete_podcast, mutation: Mutations::Podcasts::DeletePodcast
    field :refresh_podcast, mutation: Mutations::Podcasts::RefreshPodcast
    field :claim_spotify, mutation: Mutations::Podcasts::ClaimSpotify
    field :disconnect_spotify, mutation: Mutations::Podcasts::DisconnectSpotify

    # Brand
    field :register_brand, mutation: Mutations::Users::Brands::RegisterBrand
    field :onboard_brand, mutation: Mutations::Users::Brands::OnboardBrand
    field :skip_intro, mutation: Mutations::Users::Brands::SkipIntro
    field :update_brand, mutation: Mutations::Users::Brands::UpdateBrand

    # Group
    field :create_group, mutation: Mutations::Groups::CreateGroup
    field :update_group, mutation: Mutations::Groups::UpdateGroup
    field :attach_payment, mutation: Mutations::Groups::AttachPayment
    field :update_billing, mutation: Mutations::Groups::UpdateBilling

    # UserGroup
    field :update_user_group_role, mutation: Mutations::UserGroups::UpdateUserGroupRole

    # Subcription
    field :create_subscription, mutation: Mutations::Subscriptions::CreateSubscription
    field :cancel_subscription, mutation: Mutations::Subscriptions::CancelSubscription

    # Conversation
    field :create_conversation, mutation: Mutations::Conversations::CreateConversation
    field :archive_conversation, mutation: Mutations::Conversations::ArchiveConversation
    field :generate_conversation_token, mutation: Mutations::Conversations::GenerateConversationToken

    # Campaign
    field :create_campaign, mutation: Mutations::Campaigns::CreateCampaign
  end
end
