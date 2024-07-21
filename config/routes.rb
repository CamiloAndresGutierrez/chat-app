Rails.application.routes.draw do
  devise_for :users

  devise_scope :user do
    post '/login' => 'sessions#create'
    delete '/logout' => 'sessions#destroy'
    post '/sign_up' => 'registrations#create'

    namespace :api, defaults: {format: 'json'} do 
      namespace :v1 do 
        get '/users' => 'users#show'
      end
    end

  end


end

