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
    post 'user/search', to: 'users#search'
    post 'client/search', to: 'clients#search'
  end
  resources :comments, only: [:create, :edit, :update, :destroy]
  resources :attachments
  resources :user, only: %i[index edit update]

  namespace :api do
    namespace :v1 do
      resources :projects
      devise_for :users, skip: :all
      devise_scope :user do
        post 'users/sign_in', to: 'sessions#create', as: nil
        post 'users/sign_out', to: 'sessions#destroy', as: nil
      end
    end
  end
  get '404', to: 'errors#not_found'
  match '*path' => redirect('/'), via: :get
end
