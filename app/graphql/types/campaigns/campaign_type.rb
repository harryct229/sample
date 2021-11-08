# frozen_string_literal: true

module Types
  module Campaigns
    class CampaignType < Types::BaseModel
      field :name, String, null: true
      field :website, String, null: true
      field :objective, String, null: true
      field :creative_option, String, null: true
      field :budget, Float, null: true
      field :start_date, GraphQL::Types::ISO8601DateTime, null: true
      field :end_date, GraphQL::Types::ISO8601DateTime, null: true
      field :state, String, null: true
      field :budget_distributions, GraphQL::Types::JSON, null: true
      field :description, String, null: true
      field :script, String, null: true

      field :group, Types::Groups::GroupType, null: true
      def group
        Loaders::AssociationLoader.for(
          object.class, 
          :group
        ).load(object)
      end

      field :language, String, null: true
      def language
        Loaders::AssociationLoader.for(
          object.class, 
          :language
        ).load(object).then do |language|
          next if language.blank?

          language.name
        end
      end

      field :country, String, null: true
      def country
        Loaders::AssociationLoader.for(
          object.class, 
          :country
        ).load(object).then do |country|
          next if country.blank?

          country.name
        end
      end

      field :created_by, Types::Users::UserType, null: true
      def created_by
        Loaders::AssociationLoader.for(
          object.class, 
          :created_by
        ).load(object)
      end

      field :audio_url, String, null: true
      def audio_url
        Loaders::AssociationLoader.for(
          object.class,
          audio_attachment: :blob
        ).load(object).then do |audio|
          next if audio.blank?

          Rails.application.routes.url_helpers.rails_blob_url(audio)
        end
      end

      field :sponsorship_logo_url, String, null: true
      def sponsorship_logo_url
        Loaders::AssociationLoader.for(
          object.class,
          sponsorship_logo_attachment: :blob
        ).load(object).then do |sponsorship_logo|
          next if sponsorship_logo.nil?

          Rails.application.routes.url_helpers.rails_blob_url(sponsorship_logo)
        end
      end

      field :description, String, null: true
      def description
        return "" if object.description.blank?
        object.description.body.to_html
      end

      field :script, String, null: true
      def script
        return "" if object.script.blank?
        object.script.body.to_html
      end
    end
  end
end
