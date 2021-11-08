# frozen_string_literal: true

module Types
  module Users
    module Brands
      class BrandOnboardingInputType < Types::BaseInputObject
        description 'Attributes to onboard brand.'
        argument :company_name, String, 'Company name', required: true
        argument :website, String, 'Website', required: true
        argument :brand_type, String, 'Brand type', required: true
        argument :country, String, 'Country', required: true
        argument :purpose, String, 'Purpose', required: true
        argument :brand_categories, [String], 'Brand categories', required: true
        argument :avatar, ::Types::CustomTypes::FileType, 'Avatar', required: true
      end
    end
  end
end
