# frozen_string_literal: true

module Types
  module Publishers
    class PublisherInputType < Types::BaseInputObject
      argument :name, String, 'Name of publisher', required: true
      argument :description, String, 'Description of publisher', required: false
      argument :website, String, 'Website of publisher', required: false
    end
  end
end
