# frozen_string_literal: true

module Types
  module Subscriptions
    class SubscriptionType < Types::BaseModel
      field :name, String, null: true
      field :status, String, null: true
      field :cancel_at_period_end, Boolean, null: true
      field :current_period_start, GraphQL::Types::ISO8601DateTime, null: true
      field :cancel_at_period_end, GraphQL::Types::ISO8601DateTime, null: true
      field :stripe_subscription, GraphQL::Types::JSON, null: true
      field :stripe_price, GraphQL::Types::JSON, null: true
      field :api_usage, Types::ApiUsages::ApiUsageType, null: true
    end
  end
end
