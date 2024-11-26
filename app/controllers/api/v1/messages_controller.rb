# frozen_string_literal: true

module Api
  module V1
    # Controller in charge of managing Messages data and logic
    class MessagesController < ApplicationController
      include Pagination

      before_action :set_conversation, except: :list

      def new
        validate_conversation_participant

        new_message = create_new_message
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

      def list
        render json: {
          success: true,
          data: contact_messages.then(&paginate),
          meta: {
            page: page_no,
            per_page: per_page
          }
        }
      end

      private

      def contact_messages
        current_user_conversations = Conversation.find(params[:conversation_id])

        current_user_conversations.messages.order(created_at: :desc)
      end

      def validate_conversation_participant
        return if @conversation.users.find_by!(id: current_user.id).present?

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
        params.permit(
          :conversation_id,
          :content
        )
      end
    end
  end
end
