# frozen_string_literal: true

module Api
  module V1
    # Controller in charge of managing User data and logic
    class UsersController < ApplicationController
      def current
        render json: {
          success: true,
          data: current_user
        }, status: :ok
      rescue StandardError => e
        render json: { error: e.message, success: false }, status: :not_found
      end

      def contacts
        render json: {
          success: true,
          data: current_user.contacts.map { |contact| UserSerializer.new(contact) }
        }, status: :ok
      rescue StandardError => e
        render json: { error: e.message, success: false }, status: :unprocessable_entity
      end
    end
  end
end
