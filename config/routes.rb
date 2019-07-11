Rails.application.routes.draw do
  root to: 'pages#home'

  # devise / omniauth cas
  devise_for :users, controllers: { omniauth_callbacks: "users/omniauth_callbacks", sessions: 'users/sessions' }, sign_out_via: [:get]
  get '/fail', to: 'pages#failure'

  # forms 
  resources :forms

end
