# app/controllers/admin/reprocess_controller.rb
# Admin Reprocess Controller
class Admin::ReprocessController < ApplicationController
  # GET /admin/reprocess
  def index
    breadcrumb 'Admin', '/admin', title: 'Admin', match: :exact
    breadcrumb 'Reprocess', '/admin/reprocess', title: 'Reprocess Item', match: :exact
    @forms = Form.object_forms
  end

  # POST /admin/rep/:form_id
  def reprocess
    if @watermark.update(watermark_params)
      redirect_to admin_watermarks_url, success: 'Reprocess job was successfully queued.'
    else
      render :index, error: 'Unable to queue reprocessing Job.'
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_form
    @form = Form.find(params[:id])
  end

  # Only allow a trusted parameter "white list" through.
  def reprocess_params
    params.fetch(:form, {}).permit(:form_id)
  end
end
