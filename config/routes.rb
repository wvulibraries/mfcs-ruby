Rails.application.routes.draw do
  root to: 'pages#home'

  # devise / omniauth cas
  devise_for :users, controllers: { omniauth_callbacks: "users/omniauth_callbacks", sessions: 'users/sessions' }, sign_out_via: [:get]
  get '/fail', to: 'pages#failure'

  # forms
  resources :forms, :metadata_mappings, :idno_fields

  # test route for dave to not lose his mind
  get '/test', to: 'pages#test'
end
