# frozen_string_literal: true

module Types
  module Languages
    class LanguageInputType < Types::BaseInputObject
      description 'Attributes to create a Languages.'
      argument :id, ID, 'ID', required: true
      argument :code, String, 'Code', required: false
      argument :name, String, 'Name', required: false
    end
  end
end
