# frozen_string_literal: true

module Resolvers
  module Groups
    class UpcomingInvoice < Resolvers::BaseResolver
      type Types::BaseGenericType, null: true
      description 'Returns Upcoming invoice when changing subscription'

      argument :id, ID, required: true
      argument :price_nickname, String, required: true
      argument :promotion_code, String, required: false

      def resolve(id:, price_nickname:, promotion_code:)
        group = ::Group.accessible_by(current_ability).find_by(id: id)

        if group.nil?
          raise ActiveRecord::RecordNotFound,
            I18n.t('errors.messages.resource_not_found', resource: ::Group.model_name.human)
        end

        proration_date = Time.now.to_i
        subscription = group.active_subscription
        price = price_from_nickname(price_nickname)

        trial = false
        if price_nickname == "Enterprise (Trial)"
          if !group.is_trial_done
            trial = true
          end
        end

        if promotion_code.present?
          begin
            promotion_codes = Stripe::PromotionCode.list({
              code: promotion_code,
            })
            stripe_promotion_code = promotion_codes.data[0]
          rescue Exception => e
            return {
              errors: [
                { 
                  message: "Invalid promote code.",
                }
              ],
              success: false,
              data: nil,
            }
          end
        end

        if trial
          invoice_attrs = {
            customer: group.stripe_customer_id,
            invoice_items: [{
              amount: price.metadata.trial_price.to_i,
              currency: "usd",
            }],
          }
        else
          if subscription
            stripe_subscription = subscription.stripe_subscription

            if price.metadata.order.to_i < subscription.stripe_price.metadata.order.to_i
              return {
                errors: [
                  { 
                    message: "Cannot downgrade plan",
                  }
                ],
                success: false,
                data: nil,
              }
            end

            invoice_attrs = {
              customer: group.stripe_customer_id,
              subscription: subscription.external_id,
              subscription_items: [{
                id: stripe_subscription.items.data[0].id,
                price: price.id
              }],
              subscription_proration_date: proration_date,
              subscription_proration_behavior: "always_invoice",
              subscription_billing_cycle_anchor: "now",
            }
          else
            invoice_attrs = {
              customer: group.stripe_customer_id,
              subscription_items: [{
                price: price.id
              }],
            }
          end
        end

        if promotion_code.present?
          invoice_attrs[:coupon] = stripe_promotion_code.coupon.id
        end

        invoice = Stripe::Invoice.upcoming(invoice_attrs)

        return {
          errors: [],
          success: true,
          data: invoice,
        }
      end

      private
      def price_from_nickname(price_nickname)
        if price_nickname == "Enterprise (Trial)"
          price_nickname = "Enterprise"
        end
        prices = Stripe::Price.list({
          active: true,
          limit: 50
        })

        prices.data.detect {|price| price.nickname == price_nickname}
      end
    end
  end
end
