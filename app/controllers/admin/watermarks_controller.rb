# app/controllers/admin/watermarks_controller.rb
# Admin Watermarks Controller
class Admin::WatermarksController < ApplicationController
  before_action :set_watermark, only: %i[show edit update destroy]

  # GET /admin/watermarks
  def index
    breadcrumb 'Admin', '/admin', title: 'Admin', match: :exact
    breadcrumb 'Watermarks', '/admin/watermarks', title: 'Watermarks', match: :exact
    @watermarks = Watermark.all
    @watermark = Watermark.new
  end

  # GET /admin/watermarks/1/edit
  def edit; end

  # POST /admin/watermarks
  def create
    @watermark = Watermark.new(watermark_params)
    @watermarks = Watermark.all

    if @watermark.save
      redirect_to admin_watermarks_url, success: 'Watermark was successfully created.'
    else
      render :index
    end
  end

  # PATCH/PUT /admin/watermarks/1
  def update
    if @watermark.update(watermark_params)
      redirect_to admin_watermarks_url, success: 'Watermark was successfully updated.'
    else
      render :edit, error: 'Watermark was unable to update.'
    end
  end

  # DELETE /admin/watermarks/1
  def destroy
    @watermark.destroy
    redirect_to admin_watermarks_url, success: 'Watermark was successfully destroyed.'
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_watermark
    @watermark = Watermark.find(params[:id])
  end

  # Only allow a trusted parameter "white list" through.
  def watermark_params
    params.fetch(:watermark, {}).permit(:id, :name, :image)
  end
end
