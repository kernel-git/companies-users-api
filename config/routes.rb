# frozen_string_literal: true

Rails.application.routes.draw do
  mount_devise_token_auth_for 'User', at: 'auth'
  mount Rswag::Ui::Engine => '/api-docs'
  mount Rswag::Api::Engine => '/api-docs'

  namespace :v1 do
    resources :users, except: %i[new edit]
    resources :companies, except: %i[new edit]
  end

  match '*unmatched', to: 'application#route_not_recognized', via: :all
end
