class ConversationController < ApplicationController
    def new_conversation
        conversation_starter = User.find_by(username: params['sender'])
        conversation_receiver = User.find_by(username: params['recipient'])

        conversation = Conversation.create(
            admin: conversation_starter,
            title: params['title'],
            is_private: true
        )

        ConversationParticipant.create(
            conversation: conversation,
            user: conversation_starter
        )
        ConversationParticipant.create(
            conversation: conversation,
            user: conversation_starter
        )
    end
    
end
