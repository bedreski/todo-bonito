# frozen_string_literal: true

Rails.application.routes.draw do
  mount Rswag::Ui::Engine => '/api-docs'
  mount Rswag::Api::Engine => '/api-docs'

  root to: redirect('/api-docs')

  resources :users, only: %i[index create] do
    resources :tasks, only: %i[index show create] do
      patch :complete, on: :member
    end
  end
end
