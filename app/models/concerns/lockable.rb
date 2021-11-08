module Lockable
  extend ActiveSupport::Concern

  included do
    scope :unlocked, -> { where(locked_at: nil)  }
    scope :locked, -> { where.not(locked_at: nil)  }
    scope :locked_between, -> (start_time, end_time) do 
      where(locked_at: start_time..end_time)
    end
  end

  def locked?
    locked_at.present?
  end

  def lock!
    update locked_at: Time.zone.now
  end

  def unlock!
    update locked_at: nil
  end
end
