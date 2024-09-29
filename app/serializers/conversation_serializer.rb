class ConversationSerializer < ActiveModel::Serializer
  attributes :id, :title, :is_private, :admin_id
  attribute :participants

  def participants
    current_user_id = @instance_options[:scope]

    object.conversation_participants.includes(:user).map do |participant|
      next if current_user_id == participant.user.id

      {
        id: participant.user.id,
        name: participant.user.name,
        username: participant.user.username,
        email: participant.user.email
      }
    end.compact
  end
end
