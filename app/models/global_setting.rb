# == Schema Information
#
# Table name: global_settings
#
#  id              :uuid             not null, primary key
#  name            :string
#  singleton_guard :integer
#  tracking_domain :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
# Indexes
#
#  index_global_settings_on_singleton_guard  (singleton_guard) UNIQUE
#
class GlobalSetting < ApplicationRecord
  validates :singleton_guard, inclusion: { in: [0] }
  validates :tracking_domain, url: { allow_nil: true, allow_blank: true }
  validates :logo, attached: false, 
    content_type: ['image/png', 'image/jpeg'], 
    size: {less_than: 10.megabytes}
  validates :icon, attached: false, 
    content_type: ['image/png', 'image/jpeg'], 
    size: {less_than: 2.megabytes}
  validates :podcast_default_image, attached: false, 
    content_type: ['image/png', 'image/jpeg'], 
    size: {less_than: 5.megabytes}

  has_one_attached :logo
  has_one_attached :icon
  has_one_attached :podcast_default_image

  def self.instance
    first_or_create(
      singleton_guard: 0
    )
  end

  def self.method_missing(method, *args)
    if Settings.instance.methods.include?(method)
      Settings.instance.send(method, *args)
    else
      super
    end
  end
end
