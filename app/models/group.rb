# == Schema Information
#
# Table name: groups
#
#  id                 :uuid             not null, primary key
#  company_name       :string
#  is_trial_done      :boolean          default(FALSE)
#  name               :string
#  website            :string
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  country_id         :uuid
#  created_by_id      :uuid
#  parent_group_id    :uuid
#  stripe_customer_id :string
#  tier_id            :uuid             not null
#  updated_by_id      :uuid
#
# Indexes
#
#  index_groups_on_country_id       (country_id)
#  index_groups_on_created_by_id    (created_by_id)
#  index_groups_on_parent_group_id  (parent_group_id)
#  index_groups_on_tier_id          (tier_id)
#  index_groups_on_updated_by_id    (updated_by_id)
#
# Foreign Keys
#
#  fk_rails_...  (country_id => countries.id)
#  fk_rails_...  (created_by_id => users.id)
#  fk_rails_...  (parent_group_id => groups.id)
#  fk_rails_...  (tier_id => tiers.id)
#  fk_rails_...  (updated_by_id => users.id)
#
class Group < ApplicationRecord
  include UserTrackable
  include Payable

  attr_accessor :skip_priority_limits

  # - VALIDATIONS
  validates :name, presence: true
  validates :name, length: { maximum: 255 }
  validates :website, url: { allow_nil: true, allow_blank: true }
  # validates :parent_group, presence: true, unless: :root?
  validate :priority_limits, unless: :skip_priority_limits

  # - RELATIONS
  belongs_to :tier
  belongs_to :country, optional: true
  belongs_to :parent_group, class_name: "Group", foreign_key: "parent_group_id", optional: true

  has_many :user_groups, dependent: :destroy
  has_many :users, through: :user_groups
  has_many :admins, -> { UserGroup.admin }, through: :user_groups, source: :user
  has_many :child_groups, class_name: "Group", foreign_key: "parent_group_id"
  has_many :group_brand_categories, dependent: :destroy
  has_many :brand_categories, through: :group_brand_categories
  has_many :subscriptions, dependent: :destroy
  has_many :conversations, dependent: :destroy
  has_many :campaigns, dependent: :destroy

  accepts_nested_attributes_for :group_brand_categories, allow_destroy: true

  # - CALLBACKS
  # after_create :assign_admin

  def has_user?(user)
    users.exists?(user.id)
  end

  def root?
    tier.priority == 0
  end

  def active_subscription
    subscriptions.updatable.first
  end

  def subscription_is?(sub_name)
    return false unless self.active_subscription
    self.active_subscription.name.start_with?(sub_name)
  end

  def can_use_api?(action)
    return false unless active_subscription
    return false unless active_subscription.active_or_trialing?
    api_usage = active_subscription.api_usage
    api_usage.send("#{action}_quota") > 0
  end

  def use_api!(action)
    return false unless active_subscription
    return false unless active_subscription.active_or_trialing?
    api_usage = active_subscription.api_usage
    api_usage.send("#{action}_quota=", api_usage.send("#{action}_quota") - 1)
    api_usage.send("used_#{action}_quota=", api_usage.send("used_#{action}_quota") + 1)
    api_usage.save!
  end

  def email
    self.admins.first.email || self.created_by.try(:email)
  end

  private

  def priority_limits
    if User.current_user && tier && tier.priority <= User.current_user.priority
      errors.add(:tier, "cannot create group in this tier")
    end
  end

  # def assign_admin
  #   if created_by
  #     byebug
  #     self.user_groups.create(user: created_by, role: :admin)  
  #   end
  # end

  rails_admin do
    list do
      field :id
      field :name
      field :company_name
      field :tier
      field :is_trial_done
      field :parent_group
      field :users
      field :created_at
      field :updated_at
    end

    edit do
      field :name
      field :company_name
      field :website
      field :tier
      field :is_trial_done
      field :parent_group
      field :users
    end

    show do
      field :id
      field :name
      field :company_name
      field :website
      field :tier
      field :is_trial_done
      field :parent_group
      field :users
      field :created_at
      field :updated_at
    end
  end
end
