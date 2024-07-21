require_relative "boot"

require "rails/all"

require 'devise'
require 'devise/jwt'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

# Load .env file in development and test environments
if Rails.env.development? || Rails.env.test?
  Dotenv::Rails.load
end

module ChatApp
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 7.1

    def encode_token(payload)
      JWT.encode(payload, Rails.application.credentials.devise_jwt_secret_key!) 
    end

    def decoded_token
        header = request.headers['Authorization']
        if header
            token = header.split(" ")[1]
            begin
                JWT.decode(token, Rails.application.credentials.devise_jwt_secret_key!)
            rescue JWT::DecodeError
                nil
            end
        end
    end

  end
end
