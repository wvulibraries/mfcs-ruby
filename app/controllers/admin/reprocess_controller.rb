# app/controllers/admin/reprocess_controller.rb
# Admin Reprocess Controller
class Admin::ReprocessController < ApplicationController
  # before_action :set_form, only: [:edit, :create, :update]

  # GET /admin/reprocess
  def index
    breadcrumb 'Admin', '/admin', title: 'Admin', match: :exact
    breadcrumb 'Reprocess', '/admin/reprocess', title: 'Reprocess Item', match: :exact
    @forms = Form.object_forms
  end

  # GET /admin/reprocess/1
  def edit; end

  # POST /admin/reprocess
  def create
    @form = Form.find(params[:form_id])
    # if form is valid
    if !@form.nil?
      ReprocessFormJob.perform_later(@form.id)
      redirect_to :admin_reprocess_index, success: I18n.t('reprocess.success')
    else
      redirect_to :admin_reprocess_index, error: "#{params[:form_id]} Form not found unable to reprocess."
    end
  end

  # PATCH/PUT /admin/reprocess/update
  def update; end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_form
    @form = Form.find(params[:form_id])
  end

  # Only allow a trusted parameter "white list" through.
  def reprocess_params
    params.fetch(:form, {}).permit(:form_id)
  end
end
