# frozen_string_literal: true

module Mutations
  module Groups
    class CreateGroup < Mutations::BaseMutation
      description 'Create a group.'
      argument :attributes, Types::Groups::GroupInputType, required: true
      payload_type Types::Groups::GroupType

      def resolve(attributes:)
        group_attributes = attributes.to_h
        tier = group_attributes[:tier]
        tier = ::Tier.find_by(priority: tier)

        raise ActiveRecord::RecordInvalid, group unless tier

        group_attributes[:tier] = tier
        group = ::Group.new(group_attributes)

        current_ability.authorize! :create, group

        group.save!
        raise ActiveRecord::RecordInvalid, group unless group.errors.empty?

        group
      end
    end
  end
end
