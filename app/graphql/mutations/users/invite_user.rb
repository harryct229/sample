# frozen_string_literal: true

module Mutations
  module Users
    # Invites an user to your account.
    class InviteUser < Mutations::BaseMutation
      description 'Invites an user to your account.'
      argument :attributes, Types::Users::UserInvitationInputType, required: true
      payload_type Types::Users::UserType

      def resolve(attributes:)
        # create a dummy user object to check ability against create
        user = ::Brand.new(attributes.to_h)
        current_ability.authorize! :create, user

        user = ::Brand.invite!(user.attributes, context[:current_user])
        raise ActiveRecord::RecordInvalid, user unless user.errors.empty?

        user.user_groups_attributes = attributes.to_h[:user_groups_attributes]
        user.save!

        raise ActiveRecord::RecordInvalid, user unless user.errors.empty?

        user
      end
    end
  end
end
