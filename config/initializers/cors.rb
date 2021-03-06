# frozen_string_literal: true

# Be sure to restart your server when you modify this file.

# Avoid CORS issues when API is called from the frontend app.
# Handle Cross-Origin Resource Sharing (CORS) in order to accept cross-origin AJAX requests.

# Read more: https://github.com/cyu/rack-cors

Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    origins ENV['CORS_ALLOWED_URLS'] ? ENV['CORS_ALLOWED_URLS'].split(',').map(&:strip) : '0.0.0.0:8000'

    # origins '*'
    resource '*',
      headers: :any,
      expose: ['Authorization', 'RefreshToken', 'Expires'],
      methods: %i[get post options delete put]
  end
end
