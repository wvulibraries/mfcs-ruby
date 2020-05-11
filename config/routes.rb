# == Route Map
#
#                      Prefix Verb     URI Pattern                                                                              Controller#Action
#                        root GET      /                                                                                        pages#home
#            new_user_session GET      /users/sign_in(.:format)                                                                 users/sessions#new
#                user_session POST     /users/sign_in(.:format)                                                                 users/sessions#create
#        destroy_user_session GET      /users/sign_out(.:format)                                                                users/sessions#destroy
# user_cas_omniauth_authorize GET|POST /users/auth/cas(.:format)                                                                users/omniauth_callbacks#passthru
#  user_cas_omniauth_callback GET|POST /users/auth/cas/callback(.:format)                                                       users/omniauth_callbacks#cas
#           new_user_password GET      /users/password/new(.:format)                                                            devise/passwords#new
#          edit_user_password GET      /users/password/edit(.:format)                                                           devise/passwords#edit
#               user_password PATCH    /users/password(.:format)                                                                devise/passwords#update
#                             PUT      /users/password(.:format)                                                                devise/passwords#update
#                             POST     /users/password(.:format)                                                                devise/passwords#create
#                        fail GET      /fail(.:format)                                                                          pages#failure
#                       forms GET      /forms(.:format)                                                                         forms#index
#                             POST     /forms(.:format)                                                                         forms#create
#                    new_form GET      /forms/new(.:format)                                                                     forms#new
#                   edit_form GET      /forms/:id/edit(.:format)                                                                forms#edit
#                        form GET      /forms/:id(.:format)                                                                     forms#show
#                             PATCH    /forms/:id(.:format)                                                                     forms#update
#                             PUT      /forms/:id(.:format)                                                                     forms#update
#                             DELETE   /forms/:id(.:format)                                                                     forms#destroy
#            admin_watermarks GET      /admin/watermarks(.:format)                                                              admin/watermarks#index
#                             POST     /admin/watermarks(.:format)                                                              admin/watermarks#create
#        edit_admin_watermark GET      /admin/watermarks/:id/edit(.:format)                                                     admin/watermarks#edit
#             admin_watermark PATCH    /admin/watermarks/:id(.:format)                                                          admin/watermarks#update
#                             PUT      /admin/watermarks/:id(.:format)                                                          admin/watermarks#update
#                             DELETE   /admin/watermarks/:id(.:format)                                                          admin/watermarks#destroy
#                      api_v1 GET      /api/v1/form/:id(.:format)                                                               api/v1/forms#forms {:format=>:json}
#                 api_v1_form GET      /api/v1/form(.:format)                                                                   api/v1/forms#forms {:format=>:json}
#                api_v1_forms GET      /api/v1/forms(.:format)                                                                  api/v1/forms#forms {:format=>:json}
#       api_v1_forms_metadata GET      /api/v1/forms/metadata(.:format)                                                         api/v1/forms#metadata {:format=>:json}
# api_v1_forms_metadata_names GET      /api/v1/forms/metadata/names(.:format)                                                   api/v1/forms#metadata_names {:format=>:json}
#                             GET      /api/v1/form/:id/fields(.:format)                                                        api/v1/forms#field_names {:format=>:json}
#           api_v1_watermarks GET      /api/v1/watermarks(.:format)                                                             api/v1/watermarks#watermarks {:format=>:json}
#                        test GET      /test(.:format)                                                                          pages#test
#          rails_service_blob GET      /rails/active_storage/blobs/:signed_id/*filename(.:format)                               active_storage/blobs#show
#   rails_blob_representation GET      /rails/active_storage/representations/:signed_blob_id/:variation_key/*filename(.:format) active_storage/representations#show
#          rails_disk_service GET      /rails/active_storage/disk/:encoded_key/*filename(.:format)                              active_storage/disk#show
#   update_rails_disk_service PUT      /rails/active_storage/disk/:encoded_token(.:format)                                      active_storage/disk#update
#        rails_direct_uploads POST     /rails/active_storage/direct_uploads(.:format)                                           active_storage/direct_uploads#create

Rails.application.routes.draw do
  root to: 'pages#home'

  # devise / omniauth cas
  devise_for :users, controllers: { omniauth_callbacks: "users/omniauth_callbacks", sessions: 'users/sessions' }, sign_out_via: [:get]
  get '/fail', to: 'pages#failure'

  # forms
  resources :forms
  
  # Admin 
  namespace :admin do
    resources :watermarks, only: [:index, :create, :edit, :update, :destroy]
  end
  

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
      # watermarks 
      get 'watermarks', to: 'watermarks#watermarks'
    end
  end

  # test route for dave to not lose his mind
  get '/test', to: 'pages#test'
end
