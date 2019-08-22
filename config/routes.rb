# frozen_string_literal: true

Rails.application.routes.draw do
  resources :manager, only: [:index]
  resources :admin, only: [:index]
  post 'project/search', to: 'projects#search'

  namespace :manager do
    resources :projects do
      resources :payments, shallow: true
      get 'addemployees', to: 'projects#assign_employees'
      post 'addemployees', to: 'projects#create_employees_list'
      get 'emplist', to: 'projects#employee_list'
    end
    resources :clients
    post 'client/search', to: 'clients#search'
  end

  namespace :user do
    resources :projects, only: %i[index show] do
      resources :timelogs, shallow: true
    end
  end

  root 'home#index'
  devise_for :users, controllers: { registrations: :registrations }
  namespace :admin do
    resources :clients
    resources :projects do
      resources :payments, shallow: true
      resources :timelogs, shallow: true
      get 'addemployees', to: 'projects#assign_employees'
      post 'addemployees', to: 'projects#create_employees_list'
      get 'emplist', to: 'projects#employee_list'
    end
    resources :users, only: %i[index new create edit update]
    get 'update_status/:id', to: 'users#enable_disable_user', as: :change_user_status
  end

  resources :comments, only: %i[create edit update destroy]
  resources :attachments
  resources :user, only: %i[index edit update]

  post '/auth/login', to: 'authentication#login'

  namespace :api do
    namespace :v1 do
      resources :users, only: %i[index show update]
      resources :clients, only: %i[index show]
      resources :projects do
        resources :payments, shallow: true
        resources :timelogs, shallow: true
        get 'assign_employees', to: 'projects#get_employees_list'
        post 'assign_employees', to: 'projects#create_employees_list'
      end
      get 'profile', to: 'users#show_profile'
      post 'profile', to: 'users#edit_profile'
    end
  end
  get '404', to: 'errors#not_found'
  match '*path' => redirect('/'), via: :get
end
