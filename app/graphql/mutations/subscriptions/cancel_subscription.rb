# frozen_string_literal: true

module Mutations
  module Subscriptions
    class CancelSubscription < Mutations::BaseMutation
      description 'Cancel subscription'
      argument :group_id, ID, required: true

      field :errors, [::Types::Auth::Error], null: false
      field :success, Boolean, null: false
      field :group, Types::Groups::GroupType, null: false
      field :stripe_subscription, GraphQL::Types::JSON, null: false

      def resolve(group_id:)
        group = ::Group.accessible_by(current_ability).find_by(id: group_id)

        if group.nil?
          raise ActiveRecord::RecordNotFound,
            I18n.t('errors.messages.resource_not_found', resource: ::Group.model_name.human)
        end

        current_ability.authorize! :attach_payment, group
        
        return cancel_subscription(group)
      end

      private
      def cancel_subscription(group)
        subscription = group.active_subscription

        stripe_subscription = Stripe::Subscription.update(
          subscription.external_id,
          {
            cancel_at_period_end: true,
          },
        )

        {
          errors: [],
          success: true,
          group: group,
          stripe_subscription: stripe_subscription,
        }
      rescue Stripe::CardError => e
        puts [e.message, *e.backtrace].join($/)
        {
          errors: [
            { 
              message: e.message,
            }
          ],
          success: false,
          group: group,
          stripe_subscription: subscription.stripe_subscription,
        }
      rescue StandardError => e
        puts [e.message, *e.backtrace].join($/)
        {
          errors: [
            { 
              message: "Error canceling subscription. Please contact customer support.",
            }
          ],
          success: false,
          group: group,
          stripe_subscription: subscription.stripe_subscription,
        }
      end
    end
  end
end
