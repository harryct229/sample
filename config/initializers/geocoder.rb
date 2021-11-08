Geocoder.configure(
  ip_lookup: :geoip2,
  geoip2: {
    file: Rails.root.join('config/geocoder/GeoLite2-City.mmdb').to_s
  }
)
