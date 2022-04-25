# base admin controller
class AdminController < ApplicationController
  # use admin layout
  # layout 'admin'

  # run a filter with authenticatable concern
  # before_action :access_permissions unless Rails.env.test?

  # render the index of the admin section
  def home
    breadcrumb 'Admin', '/admin', title: 'Admin', match: :exact
    render :index
  end
end
