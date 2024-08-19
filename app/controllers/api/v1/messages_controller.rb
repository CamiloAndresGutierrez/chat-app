module Api::V1
    class MessagesController < ApplicationController
        before_action :set_conversation
        def new
            raise 'User has no access to this conversation.' if @conversation.conversation_participants.find_by(user_id: current_user.id).nil?

        new_message = current_user.messages.create!(
            conversation: @conversation,
            content: params['content']
            )

        if (new_message.present?)
            ConversationsChannel.broadcast_to(@conversation, new_message)
        end

        render json: { success: true, message: MessageSerializer.new(new_message) }, status: :created
        rescue ActiveRecord::RecordInvalid => e
            render json: { success: false, message: e.message }, status: :unprocessable_entity
        rescue ActiveRecord::RecordNotFound => e
            render json: { success: false, message: e.message }, status: :not_found
        end
    
        def show
            messages = @conversation.messages
            render json: { success: true, message: messages.map { |message| MessageSerializer.new(message) }}
        end

        private
        
        def set_conversation
            @conversation = Conversation.find_by!(id: params[:conversation_id])
        end
        
        def message_params
            params.require(:message).permit(:content)
        end
    end
end
