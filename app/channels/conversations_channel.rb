# frozen_string_literal: true

# Channel in charge of user conversations streaming
class ConversationsChannel < ApplicationCable::Channel
  def subscribed
    @user_conversations = Conversation.joins(:conversation_participants)
                                      .where(conversation_participants: { user_id: current_user.id })
    create_channels
  end

  def unsubscribed
    stop_all_streams
  end

  private

  def create_channels
    @user_conversations.each do |conversation|
      stream_from "conversation_#{conversation.id}"
    end
  end
end
