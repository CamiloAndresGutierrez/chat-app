# frozen_string_literal: true

module Apiv
  module V1
    # Controller in charge of managing User data and logic
    class UsersController < ApplicationController
      def contacts
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
