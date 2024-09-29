# frozen_string_literal: true

class CreateConversationParticipants < ActiveRecord::Migration[7.1]
  def change
    create_table :conversation_participants do |t|
      t.references :conversation, foreign_key: true, null: false
      t.references :user, foreign_key: true, null: false
      t.timestamps
    end
  end
end
