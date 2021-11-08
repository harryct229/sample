module UserTracker
  extend ActiveSupport::Concern

  included do
    def self.current_user=(user)
      $current_user = user
    end

    def self.current_user
      $current_user
    end    
  end
end
