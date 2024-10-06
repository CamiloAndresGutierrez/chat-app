# frozen_string_literal: true

# Model in charge of user auth and behavior
class User < ApplicationRecord
  include Devise::JWT::RevocationStrategies::JTIMatcher

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :timeoutable, :trackable, :lockable, :jwt_authenticatable, jwt_revocation_strategy: self

  has_many :conversation_participants, dependent: :destroy
  has_many :conversations, through: :conversation_participants
  has_many :messages, dependent: :destroy

  def contacts
    # Get the participants of the conversations the user is a part of
    # remove the user instance calling the method
    ConversationParticipant
      .where(conversation_id: conversations.select(:id))
      .where.not(user_id: id)
      .select('DISTINCT ON (user_id) *')
      .includes(:user)
      .map(&:user)
  end
end
