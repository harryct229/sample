# frozen_string_literal: true

module Mutations
  module Users
    module Brands
      class OnboardBrand < Mutations::BaseMutation
        description 'Brand onboard'
        argument :company_name, String, 'Company name', required: true
        argument :website, String, 'Website', required: true
        argument :brand_type, String, 'Brand type', required: true
        argument :country, String, required: true
        argument :purpose, String, 'Purpose', required: true
        argument :brand_categories, [Types::BrandCategories::BrandCategoryInputType], 'Brand categories', required: true
        argument :avatar, Types::CustomTypes::FileType, 'Avatar', required: true

        field :errors, [::Types::Auth::Error], null: false
        field :success, Boolean, null: false
        field :user, GraphQL::Auth.configuration.user_type.constantize, null: true

        def resolve(args)
          user = context[:current_user]

          group = user.groups.first

          group_brand_categories_attributes = args[:brand_categories].map do |cat|
            {
              brand_category_id: cat.id
            }
          end

          group.group_brand_categories.each do |group_brand_category|
            group_brand_categories_attributes.push({
              id: group_brand_category.id,
              _destroy: true
            })
          end

          user.update(
            state: "ready",
            purpose: args[:purpose],
            avatar: args[:avatar],
            brand_type_id: args[:brand_type],
            groups_attributes: [{
              id: group.id,
              skip_priority_limits: true,
              name: args[:company_name],
              company_name: args[:company_name],
              website: args[:website],
              country_id: args[:country],
              group_brand_categories_attributes: group_brand_categories_attributes
            }]
          )

          {
            errors: user.errors.messages.map do |field, messages|
              { 
                field: field.to_s.camelize(:lower),
                message: user.errors.full_message(field, messages.first),
              }
            end,
            success: user.errors.blank?,
            user: user.errors.blank? ? user : nil
          }
        end
      end
    end
  end
end
