# frozen_string_literal: true

Rails.application.routes.draw do
  resources :clients
  root 'home#index'
  devise_for :users, controllers: { registrations: :registrations }
  namespace :admin do
    resources :users, only: %i[index new create edit update]
    get 'update_status/:id', to: 'users#enable_disable_user', as: :change_user_status
    post 'user/search', to: 'users#search'
  end
  resources :user, only: %i[index edit update]
end
