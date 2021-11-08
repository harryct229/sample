class SubscriptionCreator
  class DowngradeSubscriptionError < StandardError; end
  class InvalidPromoteCodeError < StandardError; end

  attr_accessor :error
  attr_accessor :stripe_subscription

  def initialize(group:, price:, trial:, promotion_code:)
    @group = group
    @price = price
    @trial = trial
    @promotion_code = promotion_code
  end

  def call
    create
    self
  end

  def success?
    error.nil?
  end

  private

  #
  # This method creates a customer and then a subscription.
  # It is also responsible for catching and storing errors.
  #
  def create
    customer = create_or_update_customer
    create_subscription(customer)
  rescue DowngradeSubscriptionError => e
    self.error = 'Cannot downgrade plan.'
  rescue InvalidPromoteCodeError => e
    self.error = 'Invalid promote code.'
  rescue Stripe::CardError => e
    puts [e.message, *e.backtrace].join($/)
    self.error = e.message
  rescue StandardError => e
    puts [e.message, *e.backtrace].join($/)
    self.error = "Error creating subscription. Please contact customer support."
  end

  def create_or_update_customer
    # lock the group to try to prevent multiple records from being
    # created on the stripe side.
    @group.with_lock do
      #
      # if the group already has an associated Stripe Customer, we will update it.
      #
      if @group.stripe_customer_id.blank?
        #  Store the customer_id on the Group for later use
        @group.create_stripe_customer
      end
    end

    @group.stripe_customer
  end

  def create_subscription(customer)
    @group.with_lock do
      # Create or update subscription with Stripe, and store the details in the database

      if @promotion_code.present?
        begin
          promotion_codes = Stripe::PromotionCode.list({
            code: @promotion_code,
          })
          promotion_code = promotion_codes.data[0]

          if promotion_code.blank?
            raise InvalidPromoteCodeError.new
          end
        rescue Exception => e
          raise InvalidPromoteCodeError.new
        end
      end

      subscription = @group.active_subscription
      promotion_code_used = false

      if subscription
        stripe_subscription = subscription.stripe_subscription
        price = subscription.stripe_price

        if @price.metadata.order.to_i < price.metadata.order.to_i
          raise DowngradeSubscriptionError.new
        end

        if @trial
          if @promotion_code.present? && promotion_code.coupon.id = "TRIAL"
            promotion_code_used = true
          else
            charge_trial(customer)
          end
        end

        if @price.nickname.start_with?("Enterprise")
          if !@group.is_trial_done
            @group.is_trial_done = true
            @group.save
          end
        else
          @trial = true
        end

        subscription_attrs = {
          items: [
            {
              id: stripe_subscription.items.data[0].id,
              price: @price.id,
            }
          ],
          proration_behavior: "always_invoice",
          billing_cycle_anchor: "now",
          expand: [
            "latest_invoice.payment_intent"
          ],
          trial_from_plan: @trial,
          cancel_at_period_end: false,
        }

        if @promotion_code.present? && !promotion_code_used
          subscription_attrs[:promotion_code] = promotion_code.id
        end

        @stripe_subscription = Stripe::Subscription.update(
          subscription.external_id,
          subscription_attrs,
        )
      else
        if @trial
          if @promotion_code.present? && promotion_code.coupon.id = "TRIAL"
            promotion_code_used = true
          else
            charge_trial(customer)
          end
        end

        subscription_attrs = {
          customer: customer.id,
          items: [{price: @price.id}],
          trial_from_plan: @trial,
          expand: [
             "latest_invoice.payment_intent"
          ],
          cancel_at_period_end: false,
        }

        if @promotion_code.present? && !promotion_code_used
          subscription_attrs[:promotion_code] = promotion_code.id
        end

        @stripe_subscription = Stripe::Subscription.create(subscription_attrs)

        subscription = Subscription.new(external_id: @stripe_subscription.id, group: @group)
      end

      subscription.assign_stripe_attrs(@stripe_subscription)
      subscription.save!
    end
  end

  def charge_trial(customer)
    payment_intent = Stripe::PaymentIntent.create(
      amount: @price.metadata.trial_price.to_i,
      currency: "usd",
      customer: customer.id,
      description: "TRIAL Enterprise subscription",
      receipt_email: customer.email,
      confirm: true,
    )
    @group.is_trial_done = true
    @group.save
  end
end
