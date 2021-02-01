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
#           admin_permissions GET      /admin/permissions(.:format)                                                             admin/permissions#index
#                             POST     /admin/permissions(.:format)                                                             admin/permissions#create
#        new_admin_permission GET      /admin/permissions/new(.:format)                                                         admin/permissions#new
#       edit_admin_permission GET      /admin/permissions/:id/edit(.:format)                                                    admin/permissions#edit
#            admin_permission GET      /admin/permissions/:id(.:format)                                                         admin/permissions#show
#                             PATCH    /admin/permissions/:id(.:format)                                                         admin/permissions#update
#                             PUT      /admin/permissions/:id(.:format)                                                         admin/permissions#update
#                             DELETE   /admin/permissions/:id(.:format)                                                         admin/permissions#destroy
#                             GET      /list/:form_id(.:format)                                                                 item#list
#                      search GET      /search(.:format)                                                                        item#search
#         items_metadata GET      /items/metadata/:form_id(.:format)                                                       items/metadata#index
#     items_new_metadata GET      /items/metadata/new/:form_id(.:format)                                                   items/metadata#new
#  items_create_metadata POST     /items/metadata(.:format)                                                                items/metadata#create
#    items_edit_metadata GET      /items/metadata/:id/edit(.:format)                                                       items/metadata#edit
#   items_patch_metadata PATCH    /items/metadata/:id(.:format)                                                            items/metadata#update
#     items_put_metadata PUT      /items/metadata/:id(.:format)                                                            items/metadata#update
#  items_destroy_metdata DELETE   /items/metadata/:id(.:format)                                                            items/metadata#destroy
#                       items GET      /items/digital_object/:form_id(.:format)                                                 items/digital_object#index
#                             GET      /items/digital_object/new/:form_id(.:format)                                             items/digital_object#new
#        items_digital_object POST     /items/digital_object(.:format)                                                          items/digital_object#create
#                             GET      /items/digital_object/:id/edit(.:format)                                                 items/digital_object#edit
#                             PATCH    /items/digital_object/:id(.:format)                                                      items/digital_object#update
#                             PUT      /items/digital_object/:id(.:format)                                                      items/digital_object#update
#                      api_v1 GET      /api/v1/form/:id(.:format)                                                               api/v1/forms#forms {:format=>:json}
#                 api_v1_form GET      /api/v1/form(.:format)                                                                   api/v1/forms#forms {:format=>:json}
#                api_v1_forms GET      /api/v1/forms(.:format)                                                                  api/v1/forms#forms {:format=>:json}
#       api_v1_forms_metadata GET      /api/v1/forms/metadata(.:format)                                                         api/v1/forms#metadata {:format=>:json}
# api_v1_forms_metadata_names GET      /api/v1/forms/metadata/names(.:format)                                                   api/v1/forms#metadata_names {:format=>:json}
#                             GET      /api/v1/form/:id/fields(.:format)                                                        api/v1/forms#field_names {:format=>:json}
#           api_v1_watermarks GET      /api/v1/watermarks(.:format)                                                             api/v1/watermarks#watermarks {:format=>:json}
#          api_v1_validations GET      /api/v1/validate/validation(/:input)(/:type)(.:format)                                   api/v1/validation#validations {:format=>:json}
#          api_v1_text_length GET      /api/v1/validate/textlength(/:min)(/:max)(/:type)(.:format)                              api/v1/validation#text_length {:format=>:json}
#                             GET      /api/v1/validate/numerical(/:num)(/:num_min)(/:num_max)(/:step)(.:format)                api/v1/validation#numerical {:format=>:json}
#                        test GET      /test(.:format)                                                                          pages#test
#          rails_service_blob GET      /rails/active_storage/blobs/:signed_id/*filename(.:format)                               active_storage/blobs#show
#   rails_blob_representation GET      /rails/active_storage/representations/:signed_blob_id/:variation_key/*filename(.:format) active_storage/representations#show
#          rails_disk_service GET      /rails/active_storage/disk/:encoded_key/*filename(.:format)                              active_storage/disk#show
#   update_rails_disk_service PUT      /rails/active_storage/disk/:encoded_token(.:format)                                      active_storage/disk#update
#        rails_direct_uploads POST     /rails/active_storage/direct_uploads(.:format)                                           active_storage/direct_uploads#create
require 'sidekiq/web'

Rails.application.routes.draw do
  # Sidekiq Interface 
  # After Permissions and User Testing is added, this will need to be 
  # scoped for ADMIN permissions only.
  mount Sidekiq::Web => '/sidekiq'

  # Home
  # ========================================================
  root to: 'pages#home'

  # devise / omniauth cas
  # ========================================================
  devise_for :users, controllers: { omniauth_callbacks: "users/omniauth_callbacks", sessions: 'users/sessions' }, sign_out_via: [:get]
  get '/fail', to: 'pages#failure'

  # forms
  # ========================================================
  resources :forms
  
  # Admin 
  # ========================================================
  namespace :admin do
    resources :watermarks, only: [:index, :create, :edit, :update, :destroy]
    resources :permissions
  end

  # Item Routes 
  # ========================================================
  get 'item/list/:form_id' => 'item#list'
  get 'item/search' => 'item#search'
  
  namespace :items do
    # metadata routes 
    # ========================================================
    get    '/metadata'                       => 'metadata#index',          as: 'metadata_list'
    get    '/metadata/new/'                  => 'metadata#no_form',        as: 'metadata_no_form'
    get    '/metadata/new/:form_id'          => 'metadata#new',            as: 'new_metadata'
    post   '/metadata'                       => 'metadata#create',         as: 'create_metadata'
    get    '/metadata/:id/edit'              => 'metadata#edit',           as: 'edit_metadata'
    patch  '/metadata/:id'                   => 'metadata#update',         as: 'patch_metadata'
    put    '/metadata/:id'                   => 'metadata#update',         as: 'put_metadata'
    delete '/metadata/:id'                   => 'metadata#destroy',        as: 'destroy_metdata'
    get    '/list/metadata/:form_id'         => 'metadata#list_for_form',  as: 'metadata_list_form'
    get    '/duplicates/metadata/(:form_id)' => 'metadata#duplicates',     as: 'metadata_duplicates'

    # digital object route
    # ========================================================
    get    '/digital_objects'                     => 'digital_objects#index',          as: 'digital_objects_index'
    get    '/list/digital_objects/:form_id'       => 'digital_objects#list_for_form',  as: 'list_digital_objects'
    get    '/duplicates/digital_objects/:form_id' => 'digital_objects#duplicates',     as: 'duplicate_digital_objects'
    get    '/digital_objects/new/'                => 'digital_objects#no_form',        as: 'digital_objects_no_form'
    get    '/digital_objects/new/:form_id'        => 'digital_objects#new',            as: 'new_digital_objects'
    post   '/digital_objects'                     => 'digital_objects#create',         as: 'create_digital_objects'
    get    '/digital_objects/:id'                 => 'digital_objects#show',           as: 'show_digital_object'
    get    '/digital_objects/:id/edit'            => 'digital_objects#edit',           as: 'edit_digital_objects'
    patch  '/digital_objects/:id'                 => 'digital_objects#update',         as: 'patch_digital_objects'
    put    '/digital_objects/:id'                 => 'digital_objects#update',         as: 'put_digital_objects'
    delete '/digital_objects/:id'                 => 'digital_objects#destroy',        as: 'destroy_digital_object'
  end
  
  # API
  # ========================================================
  namespace :api do
    namespace :v1, defaults: { format: :json } do
      # forms
      # ========================================================
      get 'form/:id',               to: 'forms#forms'
      get 'form',                   to: 'forms#forms'
      get 'forms',                  to: 'forms#forms'
      get 'forms/metadata',         to: 'forms#metadata'
      get 'forms/metadata/names',   to: 'forms#metadata_names'
      get 'form/:id/fields',        to: 'forms#field_names'

      # watermarks 
      # ========================================================
      get 'watermarks', to: 'watermarks#watermarks'

      # validations
      # ========================================================
      get 'validate', to: 'validation#validations', as: 'validations'
    end
  end

  # test route for dave to not lose his mind
  get '/test', to: 'pages#test'
end
