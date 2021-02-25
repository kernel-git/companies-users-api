# frozen_string_literal: true

Rails.application.routes.draw do
  mount_devise_token_auth_for 'User', at: 'auth'
  mount Rswag::Ui::Engine => '/api-docs'
  mount Rswag::Api::Engine => '/api-docs'

  resources :users, except: %i[new edit]
  resources :companies, except: %i[new edit]

  match '*unmatched', to: 'application#route_not_recognized', via: :all
end
