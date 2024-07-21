module Api
    module V1
        class UsersController < ApplicationController            
            def show
                user = User.all
                render json: user.to_json
            rescue => e
                render json: { error: e.message, success: false }
            end
        end
    end
end