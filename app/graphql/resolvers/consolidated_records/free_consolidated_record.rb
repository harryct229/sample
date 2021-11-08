# frozen_string_literal: true

module Resolvers
  module ConsolidatedRecords
    class FreeConsolidatedRecord < Resolvers::BaseResolver
      type Types::Crawler::ConsolidatedRecords::FreeConsolidatedRecordType, null: true
      description 'Returns latest consolidated_record of all countries'

      def resolve()
        ::Crawler::ConsolidatedRecord.by_country(nil).recent.first
      end
    end
  end
end
