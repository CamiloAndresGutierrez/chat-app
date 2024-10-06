# frozen_string_literal: true

# Serializer in charge of the conversations model
class ConversationSerializer < ActiveModel::Serializer
  attributes :id, :title, :is_private, :admin_id
  attribute :participants

  def participants
    return nil unless object.association(:users).loaded?

    object.users.where.not(id: current_user_id).map do |user|
      {
        id: user.id,
        name: user.name,
        username: user.username,
        email: user.email
      }
    end
  end

  private

  def current_user_id
    @instance_options[:scope]
  end
end
