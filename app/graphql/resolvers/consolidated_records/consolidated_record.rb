# frozen_string_literal: true

module Resolvers
  module ConsolidatedRecords
    class ConsolidatedRecord < Resolvers::BaseResolver
      type Types::Crawler::ConsolidatedRecords::ConsolidatedRecordType, null: true
      description 'Returns latest consolidated_record by country'

      argument :group_id, ID, required: true
      argument :country, String, required: false

      def resolve(country:, group_id:)
        group = ::Group.accessible_by(current_ability).find_by(id: group_id)

        if group.nil?
          raise ActiveRecord::RecordNotFound,
          I18n.t('errors.messages.resource_not_found', resource: ::Group.model_name.human)
        end

        if group.can_use_api?("query")
          if country.blank?
            record = ::Crawler::ConsolidatedRecord.by_country(nil).recent.first
          else
            record = ::Crawler::ConsolidatedRecord.by_country(country).recent.first
          end
        end

        record ||= ::Crawler::ConsolidatedRecord.new
        record.mask_for(group)
      end
    end
  end
end
