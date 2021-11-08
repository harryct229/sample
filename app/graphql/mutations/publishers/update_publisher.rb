# frozen_string_literal: true

module Mutations
  module Publishers
    class UpdatePublisher < Mutations::BaseMutation
      description 'Updates Publisher.'
      argument :attributes, Types::Publishers::PublisherInputType, required: true
      payload_type Types::Publishers::PublisherType

      def resolve(id:, attributes:)
        publisher = context[:current_user].publisher
        if publisher.nil?
          raise ActiveRecord::RecordNotFound,
            I18n.t('errors.messages.resource_not_found', resource: ::Publisher.model_name.human)
        end

        current_ability.authorize! :update, publisher
        publisher.attributes = attributes.to_h
        current_ability.authorize! :update, publisher
        return publisher if publisher.save!
      end
    end
  end
end
