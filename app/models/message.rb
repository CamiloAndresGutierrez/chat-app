# frozen_string_literal: true

class Message < ApplicationRecord
  belongs_to :user
  belongs_to :conversation

  after_create :broadcast_message

  private

  def broadcast_message
    ActionCable.server.broadcast("conversation_#{conversation.id}", as_json)
  end
end
