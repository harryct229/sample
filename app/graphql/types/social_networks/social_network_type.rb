# frozen_string_literal: true

module Types
  module SocialNetworks
    class SocialNetworkType < Types::BaseModel
      field :name, String, null: true
    end
  end
end
