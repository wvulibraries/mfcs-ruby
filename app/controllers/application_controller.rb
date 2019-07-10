class ApplicationController < ActionController::Base
  # base setups
  protect_from_forgery with: :exception
  add_flash_types :success, :warning, :danger, :info, :error, :alert

  # webpacker partials
  prepend_view_path Rails.root.join('app', 'frontend')

  # authentication
  before_action :authenticate_user!
end
