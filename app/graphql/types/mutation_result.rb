# frozen_string_literal: true

module Types
  class MutationResult
    def self.call(obj: {}, success: true, errors: [])
      obj.merge(success: success, errors: errors)
    end
  end
end
