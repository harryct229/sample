# frozen_string_literal: true

module Types
  module PodcastSocialNetworks
    class PodcastSocialNetworkInputType < Types::BaseInputObject
      description 'Attributes to create a PodcastSocialNetwork.'
      argument :id, ID, 'ID', required: false
      argument :social_name, String, 'Social name', required: true
      argument :url, String, 'URL', required: false
      argument :social_id, String, 'Account ID', required: false
    end
  end
end
