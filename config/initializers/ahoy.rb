class Ahoy::Store < Ahoy::DatabaseStore
end

# set to true for JavaScript tracking
Ahoy.api = false

# set to true for geocoding
# we recommend configuring local geocoding first
# see https://github.com/ankane/ahoy#geocoding
Ahoy.geocode = true

# Ahoy.server_side_visits = :when_needed

# Ahoy.api_only = true
Ahoy.visit_duration = 1.hours
# Ahoy.cookie_domain = :all

Ahoy.exclude_method = lambda do |controller, request|
  true
end