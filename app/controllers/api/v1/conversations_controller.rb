module Api::V1
  class ConversationsController < ApplicationController
    def new
      recipient = User.find_by!(email: params['to_email'])
      conversation_exists = current_user.contacts.any? do
          |contact| contact.id === recipient.id
      end

      raise 'Conversation already exists' if conversation_exists.present? 

      new_conversation = Conversation.create!(
          admin_id: recipient.present? ? nil : current_user.id,
          title: params['title'] || "New conversation",
          is_private: recipient.present?
      )

      new_conversation.conversation_participants.create!(
          user: current_user
      )

      if (recipient.present?)
        new_conversation.conversation_participants.create!(user: recipient)            
      end

      serialized_conversation = ConversationSerializer.new(new_conversation, scope: current_user.id)
      response = { success: true, conversation: serialized_conversation.as_json }
      render json: response
    rescue ActiveRecord::RecordInvalid => e
        render json: { success: false, message: e.message }, status: :unprocessable_entity
    rescue StandardError => e
        render json: { success: false, message: e.message }, status: :unprocessable_entity
    rescue ActiveRecord::RecordNotFound => e
        render json: { success: false, message: e.message }, status: :not_found
    end
                
    def show
      render json: { success: true, conversations: current_user.conversations.map { 
        |conversation| ConversationSerializer.new(conversation, scope: current_user.id) 
      }}
    rescue ActiveRecord::RecordNotFound => e
      render json: { success: false, message: e.message }, status: :not_found
    end

    def index
      conversation = Conversation.find_by(id: params[:conversation_id])
      raise 'User has no access to this conversation.' if conversation.conversation_participants.find_by(user_id: current_user.id).nil?

      render json: {success: true, data: ConversationSerializer.new(conversation, scope: current_user.id) }, status: :ok
    end
  end
end
