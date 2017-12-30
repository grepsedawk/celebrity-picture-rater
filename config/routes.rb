# frozen_string_literal: true

Rails.application.routes.draw do
  root to: redirect('/celebrities')
  resources :celebrities, only: %i[index show] do
    resource :pictures, only: %i[new create]
  end
end
