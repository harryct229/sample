# frozen_string_literal: true

module Resolvers
  module Campaigns
    class Campaigns < Resolvers::BaseResolver
      type [Types::Campaigns::CampaignType], null: false
      description 'Returns all campaigns of a group'

      argument :group_id, ID, required: true

      def resolve(group_id:)
        group = ::Group.accessible_by(current_ability).find_by(id: group_id)

        if group.nil?
          raise ActiveRecord::RecordNotFound,
          I18n.t('errors.messages.resource_not_found', resource: ::Group.model_name.human)
        end

        group.campaigns.order(:start_date)
      end
    end
  end
end
