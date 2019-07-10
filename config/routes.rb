Rails.application.routes.draw do
  root to: 'pages#home'
  # devise / omniauth cas
  devise_for :users, controllers: { omniauth_callbacks: "users/omniauth_callbacks", sessions: 'users/sessions' }, sign_out_via: [:get]

  get '/fail', to: 'pages#failure'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
