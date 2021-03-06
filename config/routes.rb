# frozen_string_literal: true

Rails.application.routes.draw do
  resources :anime, only: [:show]
  resources :users, only: [:index]

  get :search, to: "home#search"

  root "home#index"
end
