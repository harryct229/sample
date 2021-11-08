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
class Brand < User
  # TODO: remove optional
  belongs_to :brand_type, optional: true

  accepts_nested_attributes_for :user_groups, allow_destroy: true
  accepts_nested_attributes_for :groups

  def priority
    return 0 if self.superadmin?
    _groups = user_groups.includes(group: [:tier]).map(&:group)
    priority = _groups.map(&:tier).map(&:priority).min
  end

  def in_same_group_with?(user)
    groups.any? do |group|
      group.has_user?(user)
    end
  end
end
