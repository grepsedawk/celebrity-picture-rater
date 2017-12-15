Rails.application.routes.draw do
  root to: redirect('/celebrities')
  resources :celebrities, only: %i[index show]
end
