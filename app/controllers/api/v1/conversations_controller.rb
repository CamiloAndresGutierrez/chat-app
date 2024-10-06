# frozen_string_literal: true

module Api
  module V1
    # Controller in charge of managing Conversations data and logic
    class ConversationsController < ApplicationController
      before_action :set_recipient, only: [:new]
      before_action :set_conversation, only: [:index]

      def new
        validate_conversation
        new_conversation = create_conversation_with_participants

        render json: { success: true,
                       conversation: ConversationSerializer.new(new_conversation, scope: current_user.id) }
      rescue StandardError => e
        render json: { success: false, message: e.message }, status: :unprocessable_entity
      end

      def show
        conversations = current_user.conversations.includes(:users)
        render json: { success: true, conversations: conversations.map do |conversation|
          ConversationSerializer.new(conversation, scope: current_user.id)
        end }
      rescue ActiveRecord::RecordNotFound => e
        render json: { success: false, message: e.message }, status: :not_found
      end

      def index
        raise 'User has no access to this conversation.' if @conversation.blank?

        render json: { success: true, data: ConversationSerializer.new(@conversation, scope: current_user.id) },
               status: :ok
      end

      private

      def validate_conversation
        conversation_exists = current_user.contacts.any? do |contact|
          contact.id == @recipient.id
        end

        raise 'Conversation already exists' if conversation_exists
      end

      def create_conversation_with_participants
        new_conversation = Conversation.create!(
          admin_id: @recipient.present? ? nil : current_user.id,
          title: conversation_params[:title] || 'New conversation',
          is_private: @recipient.present?
        )

        add_participant(new_conversation, current_user)
        add_participant(new_conversation, @recipient)
      end

      def add_participant(conversation, participant)
        return if participant.blank?

        conversation.conversation_participants.create!(
          user: participant
        )
      end

      def set_conversation
        @conversation = current_user.conversations
                                    .includes(:users)
                                    .find_by(id: index_conversation_params[:conversation_id])
      end

      def set_recipient
        @recipient = User.find_by!(email: conversation_params[:to_email])
      rescue ActiveRecord::RecordNotFound
        render json: { success: false, message: 'Email address is not registered in the system' }, status: :not_found
      end

      def conversation_params
        params.permit(
          :to_email,
          :title
        )
      end

      def index_conversation_params
        params.permit(
          :conversation_id
        )
      end
    end
  end
end
