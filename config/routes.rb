Rails.application.routes.draw do
  devise_for :users
  root to: 'home#index'

  namespace :users do
    resource :two_factor_settings, only: %i[edit update destroy]
  end
end
