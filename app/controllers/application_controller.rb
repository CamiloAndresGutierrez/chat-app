# frozen_string_literal: true

class ApplicationController < ActionController::API
  before_action :authenticate_user!

  private

  def authenticate_user!
    token = extract_token_from_header

    if token
      payload = decode_jwt(token)
      user_id = payload['sub']
      @current_user = User.find_by(id: user_id)

      render_unauthorized('Invalid user') if @current_user.nil?
    else
      render_unauthorized('Authorization token missing')
    end
  rescue JWT::ExpiredSignature
    render_unauthorized('Token has expired')
  rescue JWT::DecodeError
    render_unauthorized('Invalid token')
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
end
