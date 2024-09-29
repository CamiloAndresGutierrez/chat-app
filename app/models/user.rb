class User < ApplicationRecord
  include Devise::JWT::RevocationStrategies::JTIMatcher

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :timeoutable, :trackable, :lockable, :jwt_authenticatable, jwt_revocation_strategy: self

  has_many :conversation_participants
  has_many :conversations, through: :conversation_participants
  has_many :messages

  def contacts
    ConversationParticipant
      .where(conversation_id: conversations.select(:id))
      .where.not(user_id: id)
      .select('DISTINCT ON (user_id) *')
      .includes(:user)
      .map(&:user)
  end
end
