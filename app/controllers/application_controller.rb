

class ApplicationController < ActionController::Base
  # base setups
  protect_from_forgery with: :exception
  add_flash_types :success, :warning, :danger, :info, :error, :alert

  # webpacker partials
  prepend_view_path Rails.root.join('app', 'frontend')

  # authentication
  before_action :authenticate_user!

  # add a basic breadcrumb
  breadcrumb 'Home', :root_path

  layout :layout_by_resource

  private

  def layout_by_resource
    if devise_controller?
      'basic'
    else
      'application'
    end
  end
end
