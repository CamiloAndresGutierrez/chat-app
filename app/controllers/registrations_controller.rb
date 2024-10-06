# frozen_string_literal: true

# Controller in charge of user registrations
class RegistrationsController < Devise::RegistrationsController
  skip_before_action :authenticate_user!, only: %i[create]
  respond_to :json

  def create
    validate_new_user

    super
  rescue StandardError => e
    render json: { message: "User couldn't be created successfully: #{e}" }, status: :unprocessable_entity
  end

  private

  def registration_params
    params.permit(
      :email
    )
  end

  def validate_new_user
    user = User.find_by(email: registration_params[:email])

    return if user.present?

    raise 'User already exists'
  end

  def respond_with(current_user, _opts = {})
    return unless current_user

    render json: {
      success: true,
      data: UserSerializer.new(current_user)
    }, status: :ok
  end
end
