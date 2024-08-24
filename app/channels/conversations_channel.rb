class ConversationsChannel < ApplicationCable::Channel
  def subscribed
    conversation = Conversation.find(params[:conversation_id])
    reject_unauthorized_connection unless params[:token].present? &&
      User.find_by(authentication_token: params[:token]).present?

    stream_for conversation
  end

  def unsubscribed
    stop_all_streams
    # Any cleanup needed when channel is unsubscribed
  end
end
