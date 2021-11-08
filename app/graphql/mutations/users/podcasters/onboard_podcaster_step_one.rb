# frozen_string_literal: true

module Mutations
  module Users
    module Podcasters
      class OnboardPodcasterStepOne < Mutations::BaseMutation
        description 'Podcaster onboard step 1'
        argument :id, ID, required: true
        argument :name, String, 'Podcast name', required: true
        argument :feed_url, String, 'Feed URL', required: true
        argument :additional_feed_url, String, 'Additional Feed URL', required: false
        argument :languages, [Types::Languages::LanguageInputType], 'Language', required: true
        argument :countries, [Types::Countries::CountryInputType], 'Country', required: true
        argument :podcast_categories, [Types::PodcastCategories::PodcastCategoryInputType], 'Podcast categories', required: true
        # argument :avatar, Types::CustomTypes::FileType, 'Avatar', required: true

        field :errors, [::Types::Auth::Error], null: false
        field :success, Boolean, null: false
        field :user, GraphQL::Auth.configuration.user_type.constantize, null: true

        def resolve(args)
          user = context[:current_user]

          podcast = user.podcasts.accessible_by(current_ability).find_by(id: args[:id])

          if podcast.nil?
            raise ActiveRecord::RecordNotFound,
            I18n.t('errors.messages.resource_not_found', resource: ::Podcast.model_name.human)
          end

          podcast_podcast_categories_attributes = args[:podcast_categories].map do |item|
            {
              podcast_category_id: item.id
            }
          end
          podcast.podcast_podcast_categories.each do |item|
            podcast_podcast_categories_attributes.push({
              id: item.id,
              _destroy: true
            })
          end

          podcast_countries_attributes = args[:countries].map do |item|
            {
              country_id: item.id
            }
          end
          podcast.podcast_countries.each do |item|
            podcast_countries_attributes.push({
              id: item.id,
              _destroy: true
            })
          end

          podcast_languages_attributes = args[:languages].map do |item|
            {
              language_id: item.id
            }
          end
          podcast.podcast_languages.each do |item|
            podcast_languages_attributes.push({
              id: item.id,
              _destroy: true
            })
          end

          if podcast.crawler_master_podcast
            slave = podcast.crawler_master_podcast.slave_by_feed_url(args[:feed_url])

            if slave
              podcast.owner_email = slave.owner_email
              podcast.hosting = slave.hosting
            end
          end

          if user.email != podcast.owner_email
            state = "rss_verification_sent"
          else
            state = "rss_verification_done"
          end

          podcast_attributes = {
            id: podcast.id,
            state: state,
            owner_email: podcast.owner_email,
            hosting: podcast.hosting,
            name: args[:name],
            feed_url: args[:feed_url],
            additional_feed_url: args[:additional_feed_url],
            podcast_podcast_categories_attributes: podcast_podcast_categories_attributes,
            podcast_countries_attributes: podcast_countries_attributes,
            podcast_languages_attributes: podcast_languages_attributes,
          }

          user.update(
            state: state,
            podcasts_attributes: [podcast_attributes],
          )

          podcast = user.podcasts.accessible_by(current_ability).find_by(id: args[:id])
          if podcast.send(:confirmation_required?)
            podcast.send_verification_email
          end

          {
            errors: user.errors.messages.map do |field, messages|
              { 
                field: field.to_s.camelize(:lower),
                message: user.errors.full_message(field, messages.first),
              }
            end,
            success: user.errors.blank?,
            user: user.errors.blank? ? user : nil
          }
        end
      end
    end
  end
end
