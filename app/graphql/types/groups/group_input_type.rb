# frozen_string_literal: true

module Types
  module Groups
    # GraphQL Input type for a user
    class GroupInputType < Types::BaseInputObject
      argument :tier, Integer, 'Tier of group', required: true
      argument :name, String, 'Name of group', required: true
      argument :company_name, String, 'Company name of group', required: false
      argument :website, String, 'Website of group', required: false
    end
  end
end
