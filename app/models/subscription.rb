# == Schema Information
#
# Table name: subscriptions
#
#  id                   :uuid             not null, primary key
#  cancel_at_period_end :boolean          default(FALSE), not null
#  current_period_end   :datetime         not null
#  current_period_start :datetime         not null
#  status               :text             not null
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  external_id          :text             default(""), not null
#  group_id             :uuid             not null
#
# Indexes
#
#  index_subscriptions_on_group_id  (group_id)
#
# Foreign Keys
#
#  fk_rails_...  (group_id => groups.id)
#
class Subscription < ApplicationRecord
  include Stripe::Callbacks

  ACCESS_GRANTING_STATUSES = [
    "trialing",
    "active",
    # "past_due"
  ]
  UPDATABLE_STATUSES = [
    "trialing",
    "active",
    "past_due",
    "incomplete",
    "unpaid"
  ]

  enum status: {
    trialing: "trialing",
    active: "active",
    past_due: "past_due",
    canceled: "canceled",
    incomplete_expired: "incomplete_expired",
    incomplete: "incomplete",
    unpaid: "unpaid",
  }

  validates :external_id, presence: true

  belongs_to :group
  has_one :api_usage, dependent: :destroy

  scope :active_or_trialing, -> { where(status: ACCESS_GRANTING_STATUSES) }
  scope :updatable, -> { where(status: UPDATABLE_STATUSES) }
  scope :recent, -> { order("current_period_end DESC NULLS LAST") }

  def stripe_subscription
    @stripe_subscription ||= Stripe::Subscription.retrieve(self.external_id)
  end

  def stripe_price
    self.stripe_subscription.items.data[0].price
  end

  def name
    self.stripe_price.nickname
  end

  def active_or_trialing?
    ACCESS_GRANTING_STATUSES.include?(status)
  end

  def updatable?
    UPDATABLE_STATUSES.include?(status)
  end

  def assign_stripe_attrs(stripe_sub)
    assign_attributes(
      status: stripe_sub.status,
      cancel_at_period_end: stripe_sub.cancel_at_period_end,
      current_period_start: Time.at(stripe_sub.current_period_start),
      current_period_end: Time.at(stripe_sub.current_period_end)
    )
  end

  def self.update_database_subscription(stripe_sub)
    subscription = Subscription.find_by!(external_id: stripe_sub.id)
    subscription.assign_stripe_attrs(stripe_sub)
    subscription.save!
    subscription
  end

  # Stripe webhooks
  after_stripe_event! do |target, event|
    case event.type
    when "invoice.payment_succeeded"
      invoice = event.data.object
      if invoice.subscription.present?
        stripe_sub = Stripe::Subscription.retrieve(invoice.subscription)
        update_database_subscription(stripe_sub)
      end
    when "invoice.payment_failed"
      invoice = event.data.object
      if invoice.subscription.present?
        stripe_sub = Stripe::Subscription.retrieve(invoice.subscription)
        update_database_subscription(stripe_sub)
      end
    when "invoice.created"
      invoice = event.data.object
      if invoice.subscription.present?
        stripe_sub = Stripe::Subscription.retrieve(invoice.subscription)
        update_database_subscription(stripe_sub)
      end
    when "customer.subscription.created"
      stripe_sub = event.data.object
      stripe_price = stripe_sub.items.data[0].price
      subscription = update_database_subscription(stripe_sub)
      api_usage = subscription.api_usage || subscription.build_api_usage
      api_usage.query_quota = stripe_price.metadata.query_quota.to_i
      api_usage.email_quota = stripe_price.metadata.email_quota.to_i
      api_usage.used_query_quota = 0
      api_usage.used_email_quota = 0
      api_usage.save!
    when "customer.subscription.updated"
      stripe_sub = event.data.object
      stripe_price = stripe_sub.items.data[0].price
      subscription = update_database_subscription(stripe_sub)
      api_usage = subscription.api_usage || subscription.build_api_usage
      if event.data.try(:previous_attributes).try(:current_period_end) == stripe_sub.current_period_start
        api_usage.used_query_quota = 0
        api_usage.used_email_quota = 0
      end
      api_usage.query_quota = stripe_price.metadata.query_quota.to_i - api_usage.used_query_quota
      api_usage.email_quota = stripe_price.metadata.email_quota.to_i - api_usage.used_email_quota
      api_usage.save!
    when "customer.subscription.deleted"
      stripe_sub = event.data.object
      subscription = update_database_subscription(stripe_sub)
      api_usage = subscription.api_usage
      if api_usage
        api_usage.destroy!
      end
    else
      puts "Stripe webhooks - unhandled event: #{event.type}"
    end
  end
end
