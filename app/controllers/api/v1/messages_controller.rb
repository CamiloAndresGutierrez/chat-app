# frozen_string_literal: true

module Api
  module V1
    class MessagesController < ApplicationController
      before_action :set_conversation

      def new
        if @conversation.conversation_participants.find_by(user_id: current_user.id).nil?
          raise 'User has no access to this conversation.'
        end

        new_message = Message.create!(
          conversation_id: @conversation&.id,
          content: params['content'],
          user_id: current_user&.id
        )

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

      def set_conversation
        @conversation = Conversation.find_by!(id: params[:conversation_id])
      end

      def message_params
        params.require(:conversation_id, :content)
      end
    end
  end
end
