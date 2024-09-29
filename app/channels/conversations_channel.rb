# frozen_string_literal: true

class ConversationsChannel < ApplicationCable::Channel
  def subscribed
    user_conversations = Conversation.joins(:conversation_participants).where(conversation_participants: { user_id: current_user.id })
    user_conversations.each do |conversation|
      stream_from "conversation_#{conversation.id}"
    end
  end

  def unsubscribed
    stop_all_streams
  end
end
