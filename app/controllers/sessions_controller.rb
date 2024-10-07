# frozen_string_literal: true

# Controller in charge of managing and creating User sessions
class SessionsController < Devise::SessionsController
  skip_before_action :authenticate_user!, only: %i[create destroy]
  respond_to :json

  def create
    user = User.find_for_database_authentication(email: params[:user][:email])
    if user.nil? || !user.valid_password?(params[:user][:password])
      render json: { error: 'Invalid email or password.' }, status: :unauthorized and return
    end

    super
  end

  private

  def respond_with(current_user, _opts = {})
    render json: {
      success: true,
      data: UserSerializer.new(current_user)
    }, status: :ok
  end

  def respond_to_on_destroy
    current_user = validate_authorization

    if current_user
      render json: { status: 200, message: 'Logged out successfully.' }, status: :ok
    else
      render json: { status: 401, message: "Couldn't find an active session." }, status: :unauthorized
    end
  end

  def validate_authorization
    return nil if request.headers['Authorization'].blank?

    jwt_payload = JWT.decode(
      request.headers['Authorization'].split(' ').last,
      Rails.application.credentials.devise_jwt_secret_key!
    ).first

    User.find(jwt_payload['sub'])
  end

  def session_params
    params.require(:user).permit(:email)
  end
end
