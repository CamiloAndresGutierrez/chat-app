# frozen_string_literal: true

module Api
  module V1
    # Controller in charge of managing User data and logic
    class UsersController < ApplicationController
      def current
        render json: {
          success: true,
          data: UserSerializer.new(current_user)
        }, status: :ok
      rescue StandardError => e
        render json: { error: e.message, success: false }, status: :not_found
      end

      def contacts
        formatted_data = conversation_list.map do |participant|
          next if participant.user.id == current_user.id

          format_data(participant)
        end.compact

        render json: {
          success: true,
          data: formatted_data
        }, status: :ok
      rescue StandardError => e
        render json: { error: e.message, success: false }, status: :unprocessable_entity
      end

      private

      def conversation_list
        ConversationParticipant
          .includes(:user)
          .where(conversation_id: current_user.conversations.select(:id))
      end

      def format_data(participant)
        {
          id: participant.id,
          conversation_id: participant.conversation_id,
          created_at: participant.created_at,
          updated_at: participant.updated_at,
          user: {
            id: participant.user.id,
            name: participant.user.name,
            email: participant.user.email,
            active: participant.user.active
          }
        }
      end
    end
  end
end
