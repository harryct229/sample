# frozen_string_literal: true

module Resolvers
  module Groups
    # Resolver to return a user
    class Group < Resolvers::BaseResolver
      type Types::Groups::GroupType, null: true
      description 'Returns the group for a requested id'

      argument :id, ID, required: true

      def resolve(id:)
        ::Group.accessible_by(current_ability).find_by(id: id)
      end
    end
  end
end
