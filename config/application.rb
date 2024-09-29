require_relative 'boot'

require 'rails/all'

require 'devise'
require 'devise/jwt'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

# Load .env file in development and test environments
Dotenv::Rails.load if Rails.env.development? || Rails.env.test?

module ChatApp
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 7.1

    config.api_only = true

    # Remove middleware related to cookies and sessions
    config.middleware.delete ActionDispatch::Cookies
    config.middleware.delete ActionDispatch::Session::CookieStore
    config.middleware.delete ActionDispatch::Flash
    config.middleware.delete ActionDispatch::ContentSecurityPolicy::Middleware
  end
end
