# frozen_string_literal: true

class SessionsController < Devise::SessionsController
  respond_to :json

  def create
    super
  end

  def destroy
    super
  end

  private
  def respond_with(current_user, _opts = {})
    auth_token = JWT.encode(current_user, Rails.application.credentials.devise_jwt_secret_key!)
    current_user.update!(authentication_token: auth_token)

    render json: {
      success: true,
      data: UserSerializer.new(current_user)
    }, status: :ok
  end

  def respond_to_on_destroy
    if request.headers['Authorization'].present?
      jwt_payload = JWT.decode(request.headers['Authorization'].split(' ').last, Rails.application.credentials.devise_jwt_secret_key!).first
      current_user = User.find(jwt_payload['sub'])
    end

    current_user.update(authentication_token: nil)
    
    if current_user
      render json: {
        status: 200,
        message: 'Logged out successfully.'
      }, status: :ok
    else
      render json: {
        status: 401,
        message: "Couldn't find an active session."
      }, status: :unauthorized
    end
  end

  private

  def session_params
    params.require(:user).permit(:email)
  end
end