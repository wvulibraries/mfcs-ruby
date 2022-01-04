# app/controllers/admin/reprocess_controller.rb
# Admin Reprocess Controller
class Admin::ReprocessController < ApplicationController
  # GET /admin/watermarks
  def index
    breadcrumb 'Admin', '/admin', title: 'Admin', match: :exact
    breadcrumb 'Reprocess', '/admin/reprocess', title: 'Reprocess Item', match: :exact
    @forms = Form.object_forms
  end

  # Use callbacks to share common setup or constraints between actions.
end
