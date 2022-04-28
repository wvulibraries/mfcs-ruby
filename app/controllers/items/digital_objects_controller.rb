# app/controllers/items/digital_objects_controller.rb

# Items Digital Objects Controller
class Items::DigitalObjectsController < ApplicationController
  # include DigitalObjectsHelper

  before_action :set_item, only: %i[show update destroy]
  before_action :set_form, only: %i[new]

  # add a basic breadcrumb
  breadcrumb 'Select A Form', '/data_entry/select_form', title: 'Select A Form', match: :exact

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
    archive_media = nil

    if @item.valid?
      @form.file_fields.each do |field|
        # check for data
        @item[:data][field] = [] if @item[:data][field].nil?
        # if no data then make it an array
        next if item_params[:data][field].blank?

        files = []
        item_params[:data][field].each do |uploaded_file|
          # create the path if it doesn't exist 
          FileUtils.mkdir_p(@item.archive_path) unless File.directory?(@item.archive_path)

          # creates the saved file
          archive_file_path = @item.archive_path.join(uploaded_file.original_filename) 
          File.open(archive_file_path, 'wb') { |file| file.write(uploaded_file.read) }

          # creates media object in database
          archive_media = @item.media.build(
                            form_id: @form.id, 
                            media_type: :archive, 
                            filename: uploaded_file.original_filename, 
                            path: archive_file_path,
                            fieldname: field
                          )
          files << archive_media.save
        end
        @item[:data][field].concat files
      end
    end

    if @item.save
      WorkingFileJob.perform_later(archive_media.id)
      redirect_to '/items/digital_objects', success: I18n.t('digital_object.created')
    else
      # clear files because we can't insert the file back into the upload box
      @form.file_fields.each do |field|
        @item[:data][field] = []
      end
      # render the new item
      render :new
    end
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
      redirect_back(fallback_location: root_path, success: I18n.t('digital_object.updated'))
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

    # @item.update(soft_delete: true)
    # @item.save

    redirect_back(fallback_location: root_path, success: I18n.t('digital_object.destroyed'))
  end

  private

  def save_uploaded_files(item, _item_field, archive_file_path, form_id, form_field)
    files = []
    form_field.each do |uploaded_file|
      # create the path if it doesn't exist
      FileUtils.mkdir_p(item.archive_path) unless File.directory?(item.archive_path)

      # creates the saved file
      archive_file_path = item.archive_path.join(uploaded_file.original_filename)
      File.open(archive_file_path, 'wb') { |file| file.write(uploaded_file.read) }

      # creates media object in database
      archive_media = create_media(item, form_id, uploaded_file.original_filename,
                                   archive_file_path, form_field)

      files << archive_media.save
    end
  end  

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
