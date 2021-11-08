# frozen_string_literal: true

module Types
  module Groups
    class GroupType < Types::BaseModel
      field :name, String, null: false
      field :company_name, String, null: true
      field :website, String, null: true
      field :country, Types::Countries::CountryType, null: true
      field :stripe_customer, GraphQL::Types::JSON, null: true
      field :stripe_next_invoice, GraphQL::Types::JSON, null: true
      field :payment_method, GraphQL::Types::JSON, null: true
      field :stripe_charges, [GraphQL::Types::JSON], null: true
      field :active_subscription, Types::Subscriptions::SubscriptionType, null: true
      field :is_trial_done, Boolean, null: true

      field :brand_categories, [Types::BrandCategories::BrandCategoryType], null: true
      def brand_categories
        Loaders::AssociationLoader.for(
          object.class, 
          :brand_categories
        ).load(object)
      end
    end
  end
end
