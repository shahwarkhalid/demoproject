# frozen_string_literal: true

Rails.application.routes.draw do
  resources :manager, only: [:index]
  resources :admin, only: [:index]
  post 'project/search', to: 'projects#search'
  namespace :manager do
    resources :projects do
      resources :payments, shallow: true
      resources :timelogs, shallow: true
    end
    resources :clients
    post 'client/search', to: 'clients#search'
  end
  root 'home#index'
  devise_for :users, controllers: { registrations: :registrations }
  namespace :admin do
    resources :clients
    resources :projects do
      resources :payments, shallow: true
      resources :timelogs, shallow: true
    end
    resources :users, only: %i[index new create edit update]
    get 'update_status/:id', to: 'users#enable_disable_user', as: :change_user_status
    post 'user/search', to: 'users#search'
    post 'client/search', to: 'clients#search'
  end
  resources :user, only: %i[index edit update]
  get '404', to: 'errors#not_found'
  match '*path' => redirect('/'), via: :get
end
