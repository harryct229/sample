# frozen_string_literal: true

module Types
  module Languages
    # GraphQL type for a user
    class LanguageType < Types::BaseModel
      field :code, String, null: true
      field :name, String, null: true
    end
  end
end
