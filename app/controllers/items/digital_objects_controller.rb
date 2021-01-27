class Items::DigitalObjectsController < ApplicationController
  before_action :set_item, only: %i[show update destroy]
  before_action :set_form, only: %i[new]

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

    if @item.valid?
      @form.file_fields.each do |field|
        # check for data
        @item[:data][field] = [] if @item[:data][field].nil?
        # if no data then make it an array
        next if item_params[:data][field].blank?

        files = []
        item_params[:data][field].each do |uploaded_file|
          file_upload = Processing::FileUpload.new(@form.id, uploaded_file)
          files << file_upload.save
        end
        @item[:data][field].concat files
      end
    end

    if @item.save
      redirect_to '/items/digital_objects', success: 'Digital object was successfully created.'
    else
      # clear files because we can't insert the file back into the upload box
      @form.file_fields.each do |field|
        @item[:data][field] = []
      end
      # render the new item
      render :new
    end
  end

  # GET /items/digital_objects/:form_id
  def list_for_form
    @form = Form.find(params[:form_id])
    @items = Item.where(form_id: params[:form_id])
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
            file_upload = Processing::FileUpload.new(@form.id, uploaded_file)
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
    redirect_to '/items/digital_objects', error: 'Digital object was successfully destroyed.'
  end

  private

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
