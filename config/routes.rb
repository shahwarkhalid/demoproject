# frozen_string_literal: true

Rails.application.routes.draw do
  root 'users#index'
  devise_for :users
  get 'allusers', to: 'users#all_users', as: :allusers
  get 'user/:id/edit', to: 'users#edit_user', as: :edit_user
  patch 'user/:id/update_user', to: 'users#update_user', as: :update_user
  get 'user/:id/update_status', to: 'users#enable_disable_user', as: :change_user_status
end
