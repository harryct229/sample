# frozen_string_literal: true

module Mutations
  module Groups
    class UpdateBilling < Mutations::BaseMutation
      description 'Attach Stripe payment method to group'
      argument :id, ID, required: true
      argument :email, String, required: true
      argument :name, String, required: true
      argument :phone, String, required: true
      argument :address, GraphQL::Types::JSON, required: true

      field :errors, [::Types::Auth::Error], null: false
      field :success, Boolean, null: false
      field :group, Types::Groups::GroupType, null: false

      def resolve(args)
        group = ::Group.accessible_by(current_ability).find_by(id: args[:id])

        if group.nil?
          raise ActiveRecord::RecordNotFound,
            I18n.t('errors.messages.resource_not_found', resource: ::Group.model_name.human)
        end

        current_ability.authorize! :attach_payment, group
        
        if group.payment_method
          payment_method = Stripe::PaymentMethod.update(
            group.payment_method.id,
            {
              billing_details: {
                name: args[:name],
                email: args[:email],
                address: args[:address].permit!.to_h,
                phone: args[:phone],
              }
            },
          )
        end

        stripe_customer = Stripe::Customer.update(
          group.stripe_customer_id,
          {
            name: args[:name],
            email: args[:email],
            address: args[:address].permit!.to_h,
            phone: args[:phone],
          }
        )

        {
          errors: group.errors.messages.map do |field, messages|
            { 
              field: field.to_s.camelize(:lower),
              message: group.errors.full_message(field, messages.first),
            }
          end,
          success: group.errors.blank?,
          group: group.errors.blank? ? group : nil
        }
      end
    end
  end
end
