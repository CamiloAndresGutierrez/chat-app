# frozen_string_literal: true

module ApplicationCable
  # Class in charge of the connection to the web socket
  class Connection < ActionCable::Connection::Base
    identified_by :current_user

    def connect
      authenticate_user!

      self.current_user = @current_user
    end

    private

    def authenticate_user!
      token = extract_token_from_header
      reject_unauthorized_connection unless token

      payload = decode_jwt(token)
      user_id = payload['sub']

      @current_user = User.find_by(id: user_id)

      raise StandardError if @current_user.blank?
    rescue StandardError
      reject_unauthorized_connection
    end

    def extract_token_from_header
      request.headers['Authorization']&.split(' ')&.last
    end

    def decode_jwt(token)
      JWT.decode(token, Rails.application.credentials[:devise_jwt_secret_key]).first
    end
  end
end
