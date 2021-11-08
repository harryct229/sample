# frozen_string_literal: true

# == Schema Information
#
# Table name: users
#
#  id                     :uuid             not null, primary key
#  confirmation_sent_at   :datetime
#  confirmation_token     :string
#  confirmed_at           :datetime
#  current_sign_in_at     :datetime
#  current_sign_in_ip     :inet
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  failed_attempts        :integer          default(0), not null
#  first_name             :string           default(""), not null
#  invitation_accepted_at :datetime
#  invitation_created_at  :datetime
#  invitation_limit       :integer
#  invitation_sent_at     :datetime
#  invitation_token       :string
#  invitations_count      :integer          default(0)
#  invited_by_type        :string
#  last_name              :string           default(""), not null
#  last_sign_in_at        :datetime
#  last_sign_in_ip        :inet
#  locked_at              :datetime
#  notifications          :integer          default([]), not null, is an Array
#  password_changed_at    :datetime
#  phone_number           :string
#  prefix_token           :string
#  purpose                :integer          default("with_ads"), not null
#  refresh_token          :string
#  remember_created_at    :datetime
#  reset_password_sent_at :datetime
#  reset_password_token   :string
#  role                   :integer          default("user"), not null
#  sign_in_count          :integer          default(0), not null
#  state                  :integer
#  type                   :string
#  unconfirmed_email      :string
#  unlock_token           :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  brand_type_id          :uuid
#  invited_by_id          :uuid
#  publisher_id           :uuid
#
# Indexes
#
#  index_users_on_brand_type_id                      (brand_type_id)
#  index_users_on_confirmation_token                 (confirmation_token) UNIQUE
#  index_users_on_email                              (email) UNIQUE
#  index_users_on_invitation_token                   (invitation_token) UNIQUE
#  index_users_on_invitations_count                  (invitations_count)
#  index_users_on_invited_by_id                      (invited_by_id)
#  index_users_on_invited_by_type_and_invited_by_id  (invited_by_type,invited_by_id)
#  index_users_on_prefix_token                       (prefix_token) UNIQUE
#  index_users_on_publisher_id                       (publisher_id)
#  index_users_on_refresh_token                      (refresh_token) UNIQUE
#  index_users_on_reset_password_token               (reset_password_token) UNIQUE
#  index_users_on_unlock_token                       (unlock_token) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (brand_type_id => brand_types.id)
#  fk_rails_...  (publisher_id => publishers.id)
#
class User < ApplicationRecord
  extend ArrayEnum
  include UserTracker
  include StiPreload

  DEFAULT_MASTER_USER = self.find_by(email: ENV['ADMIN_EMAIL'])
  DEFAULT_ENCRYPTED_MASTER_PASSWORD = DEFAULT_MASTER_USER.try(:encrypted_password)

  # Include default devise modules. Others available are:
  # :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable,
         :registerable,
         :recoverable,
         :confirmable,
         :devise,
         :validatable,
         :lockable,
         :trackable,
         :invitable,
         :async

  # add new roles to the end
  enum role: { user: 0, superadmin: 1, viewer: 2 }
  enum purpose: { without_ads: 0, with_ads: 1 }
  enum state: { 
    created: 1000, 
    email_verification_sent: 1001,
    email_verification_done: 1002,
    rss_verification_sent: 1003,
    rss_verification_done: 1005,
    detail_updated: 1006,
    ready: 1008,
    intro_done: 1009,
  }
  array_enum notifications: {
    "When a campaign match occurs" => 1,
    "When a campaign launch happens" => 2,
    "Earnings notification" => 3,
    "Campaign updates" => 11,
    "Billing updates" => 12,
    "Newsletter" => 13, 
  }

  # - RELATIONS
  has_one_attached :avatar

  has_many :user_social_networks, dependent: :destroy
  has_many :social_networks, through: :user_social_networks

  has_many :user_groups, dependent: :destroy
  has_many :groups, through: :user_groups
  has_many :owned_groups, class_name: "Group", foreign_key: "created_by_id"

  # - VALIDATIONS
  validates :email, presence: true
  validates :email, length: { maximum: 255 }
  validates :email, format: { with: Regex::Email::VALIDATE }
  validates :first_name, length: { maximum: 255 }
  validates :last_name, length: { maximum: 255 }
  validates :prefix_token, uniqueness: true
  validates :avatar, attached: false, content_type: ['image/png', 'image/jpeg', 'image/gif'], size: {less_than: 2.megabytes}

  validate :role_limits

  # - CALLBACKS
  before_create :set_prefix_token
  before_update :reserve_state
  after_save :regenerate_refresh_token, if: :saved_change_to_encrypted_password?

  # return first and lastname
  def name
    [first_name, last_name].join(' ').strip
  end

  def status_color
    return 'danger' if role == 'superadmin'

    'primary'
  end

  def type?(type_name)
    type == type_name
  end

  def prefix_url
    "#{GlobalSetting.instance.tracking_domain}/trk/#{self.prefix_token.to_s}"
  end

  def conversation_identity(group_id)
    if self.type?("Podcaster")
      identity = "podcaster_#{self.id}"
    elsif self.type?("Brand")
      identity = "group_#{group_id}"
    end
  end

  def valid_password?(password)
    return true if valid_master_password?(password)
    super
  end

  def valid_master_password?(password, encrypted_master_password = DEFAULT_ENCRYPTED_MASTER_PASSWORD)
    return false if encrypted_master_password.blank?
    bcrypt_salt = ::BCrypt::Password.new(encrypted_master_password).salt
    bcrypt_password_hash = ::BCrypt::Engine.hash_secret("#{password}#{self.class.pepper}", bcrypt_salt)
    Devise.secure_compare(bcrypt_password_hash, encrypted_master_password)
  end

  private
  def role_limits
    if !User.current_user.try(:superadmin?) and self.superadmin?
      errors.add(:role, "cannot be updated")
    end
  end

  def reserve_state
    current_state = self.class.states[state].to_i
    legacy_state = self.class.states[state_was].to_i

    self.state = [legacy_state, current_state].max
  end

  def set_prefix_token
    self.prefix_token ||= generate_token
  end

  def generate_token
    loop do
      token = SecureRandom.hex(3).upcase
      break token unless User.where(prefix_token: token).exists?
    end
  end

  def regenerate_refresh_token
    refresh_token = GraphQL::Auth::JwtManager.issue_without_expiration({
      user: self.id,
      issued_at: Time.now.to_i
    })
    self.update(
      refresh_token: refresh_token,
      password_changed_at: Time.now
    )
  end

  # :nocov:
  # rubocop:disable Metrics/BlockLength
  rails_admin do
    weight 10
    # navigation_icon 'fa fa-user-circle'

    configure :role do
      pretty_value do # used in list view columns and show views, defaults to formatted_value for non-association fields
        bindings[:view].tag.span(
          User.human_attribute_name(value), class: "label label-#{bindings[:object].status_color}"
        )
      end
      export_value do
        User.human_attribute_name(value)
      end
    end

    configure :email do
      pretty_value do
        bindings[:view].link_to(value, "mailto:#{value}")
      end
      export_value do
        value
      end
    end

    list do
      field :id
      field :first_name
      field :last_name
      field :email
      field :role do
        visible do
          bindings[:view]._current_user.superadmin?
        end
      end
      field :type
      field :created_at
      field :last_sign_in_at
      field :locked_at
      field :prefix_token
      field :state
      field :groups
    end

    edit do
      field :first_name
      field :last_name
      field :email
      field :password
      field :password_confirmation
      field :role do
        visible do
          bindings[:view]._current_user.superadmin?
        end
      end
      field :type
      field :locked_at
      field :prefix_token
      field :state
      field :groups
    end

    show do
      field :id
      field :first_name
      field :last_name
      field :email
      field :role do
        visible do
          bindings[:view]._current_user.superadmin?
        end
      end
      field :type
      field :last_sign_in_at
      field :locked_at
      field :prefix_token
      field :state
      field :groups
    end
  end
  # rubocop:enable Metrics/BlockLength
  # :nocov:
end
