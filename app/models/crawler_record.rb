# frozen_string_literal: true

class CrawlerRecord < ActiveRecord::Base
  self.abstract_class = true

  connects_to database: { writing: :crawler, reading: :crawler_replica }

  # def readonly? 
  #   true
  # end
end
