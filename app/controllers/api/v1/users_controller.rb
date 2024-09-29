# frozen_string_literal: true

module Api
  module V1
    class UsersController < ApplicationController
      def get_contacts
        render json: {
          success: true,
          data: current_user.contacts.map { |contact| UserSerializer.new(contact) }
        }, status: :ok
      rescue StandardError => e
        render json: { error: e.message, success: false }
      end
    end
  end
end
