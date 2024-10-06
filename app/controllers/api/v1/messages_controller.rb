# frozen_string_literal: true

module Api
  module V1
    # Controller in charge of managing Messages data and logic
    class MessagesController < ApplicationController
      before_action :set_conversation

      def new
        validate_conversation_participant!

        create_new_message

        render json: { success: true, message: MessageSerializer.new(new_message) }, status: :created
      rescue ActiveRecord::RecordNotFound => e
        render json: { success: false, message: e.message }, status: :not_found
      rescue StandardError => e
        render json: { success: false, message: e.message }, status: :unprocessable_entity
      end

      def show
        messages = @conversation.messages
        render json: { success: true, message: messages.map { |message| MessageSerializer.new(message) } }
      end

      private

      def validate_conversation_participant
        return if @conversation.conversation_participants.find_by(user_id: current_user.id).blank?

        raise 'User has no access to this conversation.'
      end

      def create_new_message
        Message.create!(
          conversation_id: @conversation&.id,
          content: message_params[:content],
          user_id: current_user&.id
        )
      end

      def set_conversation
        @conversation = Conversation.find_by!(id: params[:conversation_id])
      end

      def message_params
        params.require(
          :conversation_id,
          :content
        )
      end
    end
  end
end
