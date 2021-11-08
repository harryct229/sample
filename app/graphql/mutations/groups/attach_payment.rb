# frozen_string_literal: true

module Mutations
  module Groups
    class AttachPayment < Mutations::BaseMutation
      description 'Attach Stripe payment method to group'
      argument :id, ID, required: true
      argument :payment_method_id, String, required: true

      field :errors, [::Types::Auth::Error], null: false
      field :success, Boolean, null: false
      field :group, Types::Groups::GroupType, null: false

      def resolve(id:, payment_method_id:)
        group = ::Group.accessible_by(current_ability).find_by(id: id)

        if group.nil?
          raise ActiveRecord::RecordNotFound,
            I18n.t('errors.messages.resource_not_found', resource: ::Group.model_name.human)
        end

        current_ability.authorize! :attach_payment, group
        
        group.attach_payment(payment_method_id)

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
