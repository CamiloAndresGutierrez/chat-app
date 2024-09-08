module Api::V1
  class ConversationsController < ApplicationController
    before_action :set_recipient, only: [:new]
    before_action :set_conversation, only: [:index]

    def new
      raise 'Conversation already exists' unless should_create?

      new_conversation = Conversation.create!(
          admin_id: @recipient.present? ? nil : current_user.id,
          title: conversation_params[:title] || "New conversation",
          is_private: @recipient.present?
      )

      new_conversation.conversation_participants.create!(
        user: current_user
      )

      if (@recipient.present?)
        new_conversation.conversation_participants.create!(user: @recipient)            
      end

      serialized_conversation = ConversationSerializer.new(new_conversation, scope: current_user.id)
      response = { success: true, conversation: serialized_conversation.as_json }
      render json: response
    rescue StandardError => e
      render json: { success: false, message: e.message }, status: :unprocessable_entity
    end

    def show
      render json: { success: true, conversations: current_user.conversations.map {
        |conversation| ConversationSerializer.new(conversation, scope: current_user.id) 
      }}
    rescue ActiveRecord::RecordNotFound => e
      render json: { success: false, message: e.message }, status: :not_found
    end

    def index 
      raise 'User has no access to this conversation.' unless @conversation.present?
      render json: {success: true, data: ConversationSerializer.new(@conversation, scope: current_user.id) }, status: :ok
    end

    private

    def should_create?
      conversation_exists = current_user.contacts.any? do
        |contact| contact.id === @recipient.id
      end

      !conversation_exists.present? 
    end

    def set_conversation
      @conversation = current_user.conversations.find_by(id: index_conversation_params[:conversation_id])
    end
    
    def set_recipient
      @recipient = User.find_by!(email: conversation_params[:to_email])
    rescue ActiveRecord::RecordNotFound => e
      render json: { success: false, message: "Email address is not registered in the system" }, status: :not_found
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
