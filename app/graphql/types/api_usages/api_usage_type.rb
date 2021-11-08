# frozen_string_literal: true

module Types
  module ApiUsages
    class ApiUsageType < Types::BaseModel
      field :query_quota, Integer, null: true
      field :email_quota, Integer, null: true
      field :used_query_quota, Integer, null: true
      field :used_email_quota, Integer, null: true
    end
  end
end
