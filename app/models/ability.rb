# frozen_string_literal: true

# Defines abilities for user
class Ability
  include CanCan::Ability

  def initialize(user)
    # guest user (not logged in)
    user ||= User.new

    alias_action :create, :read, :update, :destroy, to: :crud

    return if user.new_record?

    can :read, Language
    can :read, Country
    can :read, PodcastCategory
    can :read, BrandCategory
    can :read, BrandType
    can :read, Crawler::Episode
    can [:read, :update], User, id: user.id

    if user.superadmin?
      can :access, :rails_admin
      can :manage, :all
    elsif user.viewer?
      can :access, :rails_admin
      can :read, :all
    elsif user.type?("Podcaster")
      can :manage, Podcast, user_id: user.id
      can [:read, :update], Publisher, id: user.publisher_id
      
      podcasts = user.podcasts.unlocked
      podcasts.each do |podcast|
        if podcast.master_podcast_id.present?
          can :read, Conversation, master_podcast_id: podcast.master_podcast_id
        end
      end
    elsif user.type?("Brand")
      user_groups = user.user_groups.includes(group: [:tier])
      allowed_tiers = Tier.allowed_for(user)

      can :manage, :dashboard

      allowed_tiers.each do |tier|
        can :read, Tier, id: tier.id
      end

      # Admin can invite other admins or higher admin can invite
      user_groups.each do |user_group|
        if user_group.admin?
          can [:create], Group
          can [:read, :update, :create_conversation], Group, id: user_group.group_id

          if user_group.group.can_attach_payment?
            can [:attach_payment], Group, id: user_group.group_id
            can [:create_campaign], Group, id: user_group.group_id
          end

          if allowed_tiers.count == 1
            cannot :create, Group
          end

          can :manage, UserGroup, group_id: user_group.group_id
          cannot [:update, :destroy], UserGroup, role: :admin

          can :manage, User, user_groups: {
            group_id: user_group.group_id
          }
          cannot [:update, :destroy], User, user_groups: {
            role: :admin
          }
          can [:update], User, id: user.id
          can [:read, :update], Conversation, group_id: user_group.group_id
          can [:read, :update], Campaign, group_id: user_group.group_id
        else
          can :read, Group, id: user_group.group_id
          can :read, UserGroup, group_id: user_group.group_id
          can :read, User, user_groups: {
            group_id: user_group.group_id
          }
          can :read, Conversation, group_id: user_group.group_id
          can :read, Campaign, group_id: user_group.group_id
        end
      end
    end

    # See the wiki for details:
    # https://github.com/CanCanCommunity/cancancan/wiki/Defining-Abilities
  end

  def can?(action, subject, attribute = nil, *extra_args)
    subject = :dashboard if action == :dashboard

    super(action, subject, attribute, *extra_args)
  end

  private
end
