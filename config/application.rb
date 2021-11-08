# frozen_string_literal: true

require_relative 'boot'

require 'rails/all'
# Pick the frameworks you want:
# require 'active_model/railtie'
# require 'active_job/railtie'
# require 'active_record/railtie'
# require 'active_storage/engine'
# require 'action_controller/railtie'
# require 'action_mailer/railtie'
# require 'action_view/railtie'
# require 'action_cable/engine'
# require 'rails/test_unit/railtie'

# We had to require this module manually. No idea why...
require 'search_object'
require 'search_object/plugin/graphql'
require 'graphql/batch'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

# Base Module for our App
module RailsDeviseGraphql
  # Application entry point
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 6.0

    config.autoloader = :classic

    config.autoload_paths << Rails.root.join('lib')
    # config.autoload_paths << Rails.root.join("app/models/users")
    config.eager_load_paths << Rails.root.join('lib')
    # config.eager_load_paths << Rails.root.join("/app/models/users")

    config.active_record.database_selector = { delay: 2.seconds }
    config.active_record.database_resolver = ActiveRecord::Middleware::DatabaseSelector::Resolver
    config.active_record.database_resolver_context = ActiveRecord::Middleware::DatabaseSelector::Resolver::Session

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.

    # Only loads a smaller set of middleware suitable for API only apps.
    # Middleware like session, flash, cookies can be added back manually.
    # Skip views, helpers and assets when generating a new resource.

    config.time_zone = 'Singapore'

    # devise uses this for default from options
    config.action_mailer.default_options = { from: ENV['DEVISE_MAILER_FROM'] }

    # Stripe
    # config.stripe.auto_mount = false
    config.stripe.secret_key = ENV['STRIPE_SECRET_KEY']
    config.stripe.signing_secrets = [
      ENV['STRIPE_SIGNING_SECRET']
    ]

    # Twilio
    config.middleware.use Rack::TwilioWebhookAuthentication, ENV['TWILIO_AUTH_TOKEN'], '/twilio_webhook'
  end
end
