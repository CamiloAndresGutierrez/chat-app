Rails.application.routes.draw do
  devise_for :users

  devise_scope :user do
    post '/login' => 'sessions#create'
    delete '/logout' => 'sessions#destroy'
    post '/sign_up' => 'registrations#create'

    namespace :api, defaults: {format: 'json'} do 
      namespace :v1 do
        get 'users/get_contacts' => 'users#get_contacts'

        get '/conversations' => 'conversations#show'
        post '/conversations' => 'conversations#new'
        post '/:conversation_id/conversations' => 'conversations#index'

        get '/:conversation_id/message' => 'messages#show'
        post '/:conversation_id/message' => 'messages#new'
      end
    end

  end


end

