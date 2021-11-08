# frozen_string_literal: true

module Types
  module Users
    # GraphQL type for a user
    class UserType < Types::BaseModel
      field :name, String, null: false
      field :first_name, String, null: false
      field :last_name, String, null: false
      field :phone_number, String, null: true
      field :email, String, null: true
      field :unconfirmed_email, String, null: true
      field :purpose, String, null: true
      field :prefix_token, String, null: true
      field :prefix_url, String, null: true
      field :state, String, null: true
      field :role, String, null: true
      field :notifications, [String], null: true

      field :type, String, null: true
      def type
        if object.superadmin?
          return "Admin"
        end
        object.type
      end

      field :is_ready, Boolean, null: true
      def is_ready
        object.ready? || object.intro_done?
      end

      field :brand_type, Types::BrandTypes::BrandTypeType, null: true
      def brand_type
        return nil if object.type == "Podcaster"
        return object.brand_type
      end

      field :user_groups, [Types::UserGroups::UserGroupType], null: true
      def user_groups
        return nil if !object.type?("Brand")
        Loaders::AssociationLoader.for(
          object.class, 
          user_groups: :group
        ).load(object)
      end

      field :groups, [Types::Groups::GroupType], null: true
      def groups
        return nil if !object.type?("Brand")
        Loaders::AssociationLoader.for(
          object.class, 
          :groups
        ).load(object)
      end

      field :podcasts, [Types::Podcasts::PodcastType], null: true
      def podcasts
        return nil if !object.type?("Podcaster")
        Loaders::AssociationLoader.for(
          object.class, 
          :podcasts
        ).load(object)
      end

      field :publisher, [Types::Publishers::PublisherType], null: true
      def publisher
        return nil if !object.type?("Podcaster")
        Loaders::AssociationLoader.for(
          object.class, 
          :publisher
        ).load(object)
      end

      field :is_confirmed, Boolean, null: false
      def is_confirmed
        object.confirmed?
      end

      field :is_locked, Boolean, null: false
      def is_locked
        object.access_locked?
      end

      field :avatar_url, String, null: true
      def avatar_url
        Loaders::AssociationLoader.for(
          object.class,
          avatar_attachment: :blob
        ).load(object).then do |avatar|
          next if avatar.nil?

          Rails.application.routes.url_helpers.rails_blob_url(avatar)
        end
      end
    end
  end
end
