# frozen_string_literal: true

module Types
  module Countries
    # GraphQL type for a user
    class CountryType < Types::BaseModel
      field :code, String, null: true
      field :name, String, null: true
    end
  end
end
