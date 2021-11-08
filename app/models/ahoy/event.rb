# == Schema Information
#
# Table name: ahoy_events
#
#  id         :bigint           not null, primary key
#  name       :string
#  properties :jsonb
#  time       :datetime
#  user_id    :bigint
#  visit_id   :bigint
#
# Indexes
#
#  index_ahoy_events_on_name_and_time  (name,time)
#  index_ahoy_events_on_properties     (properties) USING gin
#  index_ahoy_events_on_user_id        (user_id)
#  index_ahoy_events_on_visit_id       (visit_id)
#
class Ahoy::Event < ApplicationRecord
  include Ahoy::QueryMethods

  self.table_name = "ahoy_events"
  self.implicit_order_column = :id
  self.rollup_column = :time

  belongs_to :visit
  belongs_to :user, optional: true
end

# http://5f6a30724f1d.ngrok.io/trk/9834C9/https://anchor.fm/s/160521dc/podcast/play/11059039/https%3A%2F%2Fd3ctxlq1ktw2nl.cloudfront.net%2Fproduction%2F2020-2-13%2F56353398-44100-2-e0d8581546a98.mp3

# Ahoy::Visit.group(:country_code, :region, :city, :os, :device_type, :browser).rollup("Orders by platform and channel")

# Ahoy::Event.last.properties["episode_id"]

# Ahoy::Event.where(name: "Viewed homepage").joins(:visit).rollup("Homepage views") { |r| r.distinct.count(:visitor_token) }

# Ahoy::Event.where(name: "Listen Episode").group_prop(:episode_id).rollup("Episode listener")

# Ahoy::Event.where(name: "Listen Episode").joins(:visit).group_prop(:episode_id).group(:ip, :country_code, :region, :city, :os, :device_type, :browser).rollup("Episode unique listener", last: 3) { |r| r.distinct.count(:visitor_token) }

# Ahoy::Event.where(name: "Listen Episode").joins(:visit).group_prop(:episode_id).group(:ip, :country_code, :region, :city, :os, :device_type, :browser).rollup("Episode listener", last: 3)

# Ahoy::Event.where(name: "Listen Episode").joins(:visit).group_prop(:podcast_id).group(:ip, :country_code, :region, :city, :os, :device_type, :browser).rollup("Podcast unique listener", last: 3) { |r| r.distinct.count(:visitor_token) }

# Ahoy::Event.where(name: "Listen Episode").joins(:visit).group_prop(:podcast_id).group(:ip, :country_code, :region, :city, :os, :device_type, :browser).rollup("Podcast listener", last: 3)

# Rollup.where_dimensions(episode_id: 64504004).multi_series("Episode listener")


