# frozen_string_literal: true

# config/initializers/cors.rb

Rails.application.config.middleware.insert_before 0, Rack::Cors, debug: true do
  allow do
    origins 'http://localhost:5173'
    resource '*', headers: :any, methods: %i[get post delete put], credentials: true, expose: ['Authorization']
  end
end
