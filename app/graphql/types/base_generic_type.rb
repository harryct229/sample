# frozen_string_literal: true

module Types
  class BaseGenericType < GraphQL::Schema::Object
    field :errors, [::Types::Auth::Error], null: false
    field :success, Boolean, null: false
    field :data, GraphQL::Types::JSON, null: true
  end
end
