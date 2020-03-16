Rails.application.routes.draw do
  root to: 'pages#home'

  # devise / omniauth cas
  devise_for :users, controllers: { omniauth_callbacks: "users/omniauth_callbacks", sessions: 'users/sessions' }, sign_out_via: [:get]
  get '/fail', to: 'pages#failure'

  # forms
  resources :forms, :metadata_mappings, :idno_fields, :text_fields, :check_fields

  # API
  namespace :api do
    namespace :v1, defaults: { format: :json } do
      # forms
      get 'form/:id', to: 'forms#forms'
      get 'form', to: 'forms#forms'
      get 'forms', to: 'forms#forms'
      get 'forms/metadata', to: 'forms#metadata'
      get 'forms/metadata/names', to: 'forms#metadata_names'
      get 'form/:id/fields', to: 'forms#field_names'
    end
  end

  # test route for dave to not lose his mind
  get '/test', to: 'pages#test'
end
