# app/controllers/items/digital_objects_controller.rb

# Items Digital Objects Controller
class Items::DigitalObjectsController < ApplicationController
  # include DigitalObjectsHelper

  before_action :set_item, only: %i[show update destroy]
  before_action :set_form, only: %i[new]

  # add a basic breadcrumb
  breadcrumb 'Select A Form', '/forms'

  # GET /items/digital_objects
  def index
    @forms = Form.object_forms
  end

  # GET /items/digital_objects/1
  def show
    @form = Form.find(@item.form_id)
  end

  # GET /items/digital_objects/new
  def new
    @item = Item.new
  end

  # GET /items/digital_objects/1/edit
  def edit
    @item = Item.find(params[:id])
    @form = Form.find(@item.form_id)
  end

  # POST /items/digital_objects
  def create
    @item = Item.new(item_params)
    @form = Form.find(item_params[:form_id])
    # archive_media = nil

    if @item.valid?
      @form.file_fields.each do |field|
        # check for data
        @item[:data][field] = [] if @item[:data][field].nil?
        # if no data then make it an array
        next if item_params[:data][field].blank?

        files = helper.save_uploaded_files(@item, item_params[:data][field], archive_file_path, @form.id, field)
        @item[:data][field].concat files
      end
    end

    if @item.save
      WorkingFileJob.perform_later(archive_media.id)
      redirect_to '/items/digital_objects', success: 'Digital object was successfully created.'
    else
      # clear files because we can't insert the file back into the upload box
      clear_item_fields
      # render the new item
      render :new
    end
  end

  # GET /items/digital_objects/dataview/:form_id
  def form_dataview_list
    media = Media.where(form_id: params[:form_id])
    @form = Form.find(params[:form_id])
    @items = Item.order(:idno).limit(25).where(form_id: params[:form_id], metadata: false)
  end

  # GET /items/digital_objects/shelf/:form_id
  def form_shelf_list
    media = Media.where(form_id: params[:form_id])
    @form = Form.find(params[:form_id])
    @items = Item.order(:idno).limit(25).where(form_id: params[:form_id], metadata: false)
  end  

  # GET /items/digital_objects/:form_id
  def form_thumbnail_list
    media = Media.where(form_id: params[:form_id])
    @display_thumb_field = media.count.positive?
    @form = Form.find(params[:form_id])
    @items = Item.order(:idno).where(form_id: params[:form_id], metadata: false)
  end

  # PATCH/PUT /items/digital_objects/1
  def update
    @form = Form.find(@item.form_id)
    @item.attributes = item_params

    if @item.valid?
      @form.file_fields.each do |field|
        @item[:data][field] = [] if @item[:data][field].nil?
        files = []
        if item_params[:data][field].present?
          item_params[:data][field].each do |uploaded_file|
            file_upload = Processing::FileUpload.new(@item.id, uploaded_file, field)
            files << file_upload.save
          end
        end
        @item[:data][field].concat files
      end
    end

    if @item.valid? && @item.save
      redirect_to '/items/digital_objects', success: 'Digital object was successfully updated.'
    else
      # clear files because we can't insert the file back into the upload box
      @form.file_fields.each do |field|
        item_params[:data][field]
      end

      # render the new item
      render :edit
    end
  end

  # DELETE /items/digital_objects/1
  def destroy
    @item.destroy
    redirect_to '/items/digital_objects', success: 'Digital object was successfully destroyed.'
  end

  # /item/digital_objects/:id/reprocess
  def reprocess
    ReprocessItemJob.perform_later(params[:id])
    redirect_to '/items/digital_objects', success: 'Digital object Reprocessing Job Has been queued.'
  end

  private

  def clear_item_fields
    @form.file_fields.each do |field|
      @item[:data][field] = []
    end
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_item
    @item = Item.find(params[:id])
  end

  def set_form
    @form = Form.find(params[:form_id])
  end

  # Only allow a trusted parameter "white list" through.
  def item_params
    params.require(:item).permit(:form_id, :metadata, :public_release, data: {})
  end
end
