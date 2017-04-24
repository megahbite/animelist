# frozen_string_literal: true

Rails.application.routes.draw do
  resources :anime, only: [:show]

  root "home#index"
end
