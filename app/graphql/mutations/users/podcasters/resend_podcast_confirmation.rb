# frozen_string_literal: true

module Mutations
  module Users
    module Podcasters
      class ResendPodcastConfirmation < Mutations::BaseMutation
        description 'Resend podcast confirmation'
        argument :id, ID, required: true

        field :errors, [::Types::Auth::Error], null: false
        field :success, Boolean, null: false
        field :podcast, Types::Podcasts::PodcastType, null: true

        def resolve(args)
          user = context[:current_user]

          podcast = user.podcasts.accessible_by(current_ability).find_by(id: args[:id])

          if podcast.nil?
            raise ActiveRecord::RecordNotFound,
            I18n.t('errors.messages.resource_not_found', resource: ::Podcast.model_name.human)
          end

          if podcast.send(:confirmation_required?)
            podcast.send_verification_email
          end

          {
            errors: [],
            success: true,
            podcast: podcast
          }
        end
      end
    end
  end
end
