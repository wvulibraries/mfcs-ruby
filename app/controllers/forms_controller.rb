class FormsController < ApplicationController

  before_action :set_form, only: [:show, :edit, :update, :destroy]
  before_action :access_params_hash, only: [:create, :update]

  # GET /forms
  def index
    breadcrumb 'List Forms', forms_path, title: 'List Forms'
    @form = Form.object_forms
    @metadata_forms = Form.metadata_forms
  end

  # GET /forms
  def show; end

  # GET /forms
  def new
    breadcrumb 'List Forms', '/forms', title: 'List Forms', match: :exact
    breadcrumb 'New Form', '/forms/new', title: 'New Form', match: :exact
    @form = Form.new
    @forms = Form.metadata_forms
  end

  # GET /forms/1/edit
  def edit 
    @forms = Form.metadata_forms
  end

  # POST /forms
  def create
    @form = Form.new(form_params)
    @form.fields = @parsed_field_params
    @forms = Form.metadata_forms
    respond_to do |format|
      if @form.save
        format.html { redirect_to form_path(@form), success: I18n.t('form.success') }
      else
        format.html { render :new }
      end
    end
  end

  # PATCH/PUT /forms/1
  def update
    respond_to do |format|
      if @form.update(update_params)
        format.html { redirect_to form_path(@form), success: I18n.t('form.edited') }
      else
        format.html { render :edit }
      end
    end
  end

  # DELETE /forms/1
  def destroy
    @form.destroy
    respond_to do |format|
      format.html { redirect_to '/admin/forms', success: I18n.t('form.deleted') }
    end
  end

  # Private Methods
  private

  # set unsafe params for post
  def access_params_hash
    unsafe_params = params.to_unsafe_hash
    @parsed_field_params = JSON.parse(unsafe_params["form"]["fields"])
  end 

  # Use callbacks to share common setup or constraints between actions.
  def set_form
    @form = Form.find(params[:id])
  end

  def form_params
    params.fetch(:form, {}).permit(:id, :title, :display_title, :description, :submit_button, :update_button, :container, :production, :export_public, :export_oai, :object_public_release_show, :object_public_release_default, :fields, :idno, :permissions, :navigation, :metadata, permissions_attributes: %i[id form_id user_id permission _destroy],)
  end

  def update_params 
    unsafe_params = params.to_unsafe_hash["form"]
    unsafe_params['fields'] = JSON.parse(unsafe_params['fields']); 
    unsafe_params.slice('id', 'title', 'display_title', 'description', 'submit_button', 'update_button', 'container', 'production', 'export_public', 'export_oai', 'object_public_release_show', 'object_public_release_default', 'fields', 'idno', 'permissions_attributes', 'navigation', 'metadata')
  end 
end
