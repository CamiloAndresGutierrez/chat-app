# frozen_string_literal: true

class RegistrationsController < Devise::RegistrationsController
  respond_to :json
  # before_action :configure_sign_up_params, only: [:create]
  # before_action :configure_account_update_params, only: [:update]

  private

  def respond_with(current_user, _opts = {})
    if resource.persisted?
      render json: {
        success: true,
        data: UserSerializer.new(current_user)
      }, status: :ok
    else
      render json: {
        status: { message: "User couldn't be created successfully. #{current_user.errors.full_messages.to_sentence}" }
      }, status: :unprocessable_entity
    end
  end
end
