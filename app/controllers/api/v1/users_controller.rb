module Api::V1
    class UsersController < ApplicationController            
        def get_contacts
            render :json => {
                success: true,
                data: current_user.contacts.map { | contact | UserSerializer.new(contact) }
            }, status: :ok
        rescue => e
            render json: { error: e.message, success: false }
        end
    end
end
