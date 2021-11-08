# frozen_string_literal: true

module Mutations
  module Users
    module Podcasters
      class OnboardPodcasterStepFour < Mutations::BaseMutation
        description 'Podcaster onboard Step 4'
        argument :id, ID, required: true

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

          user.update(
            state: "ready",
            podcasts_attributes: [{
              id: podcast.id,
              state: "ready",
            }],
          )

          crawler_master_podcast = podcast.crawler_master_podcast
          if crawler_master_podcast
            podcasts = crawler_master_podcast.podcasts.where.not(id: podcast.id).where(locked_at: nil)
            podcasts.each do |_podcast|
              _podcast.lock!
              # TODO: Update participation in conversation
            end
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
