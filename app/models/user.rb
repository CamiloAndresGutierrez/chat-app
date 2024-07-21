class User < ApplicationRecord
  include Devise::JWT::RevocationStrategies::JTIMatcher

  devise :database_authenticatable, :registerable,
    :recoverable, :rememberable, :validatable,
    :trackable, :lockable, :jwt_authenticatable, jwt_revocation_strategy: self

  has_many :conversation_participants
  has_many :conversations, through: :conversation_participants
  has_many :messages
end
  