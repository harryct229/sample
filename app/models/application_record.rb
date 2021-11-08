# frozen_string_literal: true

# Base class for all application records
class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true
  self.implicit_order_column = :created_at

  connects_to database: { writing: :primary, reading: :primary }
end
