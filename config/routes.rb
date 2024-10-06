# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users

  devise_scope :user do
    post '/login' => 'sessions#create'
    delete '/logout' => 'sessions#destroy'
    post '/sign_up' => 'registrations#create'
  end

  namespace :api, defaults: { format: 'json' } do
    namespace :v1 do
      get 'users/contacts' => 'users#contacts'
      get '/conversations' => 'conversations#show'
      post '/conversations' => 'conversations#new'
      get '/conversations/:conversation_id' => 'conversations#index'
      post '/conversations/:conversation_id/message' => 'messages#new'
      get '/conversations/:conversation_id/message' => 'messages#show'
    end
  end

  mount ActionCable.server => '/cable'

  resources :users
  resources :messages
  resources :channels
end
