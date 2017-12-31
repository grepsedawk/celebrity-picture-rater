# frozen_string_literal: true

Rails.application.routes.draw do
  root to: redirect('/celebrities')
  resources :celebrities, only: %i[index show] do
    resource :pictures, only: %i[new create]
    resource :vote, only: %i[new] do
      get ':id/left', action: 'left'
      get ':id/right', action: 'right'
    end
  end
end
