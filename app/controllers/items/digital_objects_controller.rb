class Items::DigitalObjectsController < ApplicationController
  before_action :set_item, only: %i[show update destroy]
  before_action :set_form, only: %i[new]

  # GET /items/digital_objects
  def index
    @forms = Form.object_forms
  end

  # GET /items/digital_objects/1
  def show; end

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

    # media_uuids = []

    # @form.file_fields.each do |field|
    #   item_params[:data][field].each do |uploaded_file|
    #     file_attributes = {
    #       filename: uploaded_file.original_filename,
    #       form_id: @form.id,
    #       size: uploaded_file.size,
    #       mime_type: uploaded_file.content_type
    #     }

    #     media = Media.new(file_attributes)

    #     # make directories
    #     FileUtils.mkdir_p(media.archival_path) unless File.directory?(media.archival_path)
    #     FileUtils.mkdir_p(media.working_path) unless File.directory?(media.working_path)

    #     # archive
    #     archive_path = media.archival_path.join(uploaded_file.original_filename)
    #     File.open(archive_path, 'wb') do |file|
    #       file.write(uploaded_file.read)
    #     end

    #     # working copy
    #     working_path = media.working_path.join(uploaded_file.original_filename)
    #     File.open(working_path, 'wb') do |file|
    #       file.write(uploaded_file.read)
    #     end

    #     # set fileinfo
    #     media.file_info(media.working_path.join(uploaded_file.original_filename))
    #     media.path = working_path

    #     # save the media
    #     media.save
    #     media_uuids = media.uuid
    #   end
    # end

    # @item.data['files']['media_uuids'] = media_uuids

    @item.errors.add(:base, 'Testing some shit.')

    if @item.save
      redirect_to '/items/digital_objects', success: 'Digital object was successfully created.'
    else
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
    if @item.update(item_params)
      redirect_to '/items/digital_objects', success: 'Digital object was successfully updated.'
    else
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
