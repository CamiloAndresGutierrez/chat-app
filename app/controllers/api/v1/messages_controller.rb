module Api
    module V1
        class MessagesController < ApplicationController
            def new
                conversation = Conversation.find_by!(id: params[:conversation_id])
                raise 'User has no access to this conversation.' if conversation.conversation_participants.find_by(user_id: current_user.id).nil?

                new_message = current_user.messages.create!(
                    conversation: conversation,
                    content: params['content']
                )
                render json: { success: true, message: MessageSerializer.new(new_message) }
            rescue ActiveRecord::RecordInvalid => e
                render json: { success: false, message: e.message }, status: :unprocessable_entity
            rescue ActiveRecord::RecordNotFound => e
                render json: { success: false, message: e.message }, status: :not_found
            end

            def show
                messages = Conversation.find_by!(id: params[:conversation_id]).messages
                render json: { success: true, message: messages.map { |message| MessageSerializer.new(message) }}
            end
        end
    end
end
