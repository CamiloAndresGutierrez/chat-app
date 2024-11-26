# frozen_string_literal: true

# The application controller
class ApplicationController < ActionController::API
  before_action :authenticate_user!

  private

  def authenticate_user!
    set_token
    raise StandardError, 'Authorization token missing' unless @token

    decode_and_set_user

    raise StandardError, 'Invalid user' if @current_user.nil?
  rescue JWT::ExpiredSignature
    render_unauthorized('Token has expired')
  rescue JWT::DecodeError
    render_unauthorized('Invalid token')
  rescue StandardError => e
    render_unauthorized(e.message)
  end

  def extract_token_from_header
    request.headers['Authorization']&.split(' ')&.last
  end

  def decode_jwt(token)
    JWT.decode(token, Rails.application.credentials[:devise_jwt_secret_key]).first
  end

  def render_unauthorized(message)
    render json: { error: message }, status: :unauthorized
  end

  def set_token
    @token = extract_token_from_header
  end

  def decode_and_set_user
    payload = decode_jwt(@token)
    user_id = payload['sub']
    @current_user = User.find_by(id: user_id)
  end
end
