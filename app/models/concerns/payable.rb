module Payable
  extend ActiveSupport::Concern

  included do
    after_create :create_stripe_customer, if: :can_attach_payment?
    after_update :update_stripe_customer, if: :can_attach_payment?
  end

  def can_attach_payment?
    tier.priority == 2
  end

  def stripe_customer
    @stripe_customer ||= Stripe::Customer.retrieve(self.stripe_customer_id)
  end

  def payment_method
    @payment_method ||= Stripe::PaymentMethod
      .retrieve(self.stripe_customer.invoice_settings.default_payment_method)
  rescue Exception => e
    nil      
  end

  def stripe_next_invoice
    @stripe_next_invoice ||= Stripe::Invoice.upcoming(
      customer: self.stripe_customer_id,
    )
  rescue Exception => e
    nil
  end

  def stripe_charges
    @stripe_charges ||= Stripe::Charge.list(
      customer: self.stripe_customer_id,
      limit: 20
    ).data
  end

  def create_stripe_customer
    customer = Stripe::Customer.create(
      name: self.name,
      email: self.created_by.email,
      description: self.company_name,
      metadata: {
        group_id: self.id
      }
    )

    self.stripe_customer_id = customer.id
    self.save!
  end

  def update_stripe_customer
    customer = Stripe::Customer.update(
      self.stripe_customer_id,
      {
        description: self.company_name,
        metadata: {
          name: self.name,
          company_name: self.company_name,
          group_id: self.id
        }
      }
    )
  end

  def attach_payment(payment_method_id)
    payment_method = Stripe::PaymentMethod.retrieve(payment_method_id)

    Stripe::PaymentMethod.attach(
      payment_method_id,
      {
        customer: self.stripe_customer_id
      },
    )

    stripe_customer = Stripe::Customer.update(
      self.stripe_customer_id,
      {
        name: payment_method.billing_details.name,
        address: payment_method.billing_details.address.to_h,
        phone: payment_method.billing_details.phone,
        invoice_settings: {
          default_payment_method: payment_method_id
        }
      }
    )
  end
end
