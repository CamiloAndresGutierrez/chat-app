class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable

  devise :database_authenticatable, :registerable,
          :jwt_authenticatable, jwt_revocation_strategy: self

  has_many :conversation_participants
  has_many :conversations, through: :conversation_participants
  has_many :messages
end
  