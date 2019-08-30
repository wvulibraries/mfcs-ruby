class FormsController < ApplicationController
  add_breadcrumb "home", :root_path
  
  # GET /forms
  def index
    add_breadcrumb 'List Forms', forms_path, title: 'List Forms'
    @form = Form.order(:name)
  end

  # GET /forms
  def show; end

  # GET /forms
  def new
    @form = Form.new
  end

  # GET /forms/1/edit
  def edit; end

  # POST /forms
  def create
    @form = Form.new(form_params)
    respond_to do |format|
      if @form.save
        format.html { redirect_to admin_form_path(@form), success: I18n.t('form.success') }
      else
        format.html { render :new }
      end
    end
  end

  # PATCH/PUT /forms/1
  def update
    respond_to do |format|
      if @form.update(form_params)
        format.html { redirect_to admin_form_path(@form), success: I18n.t('form.edited') }
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

  # Use callbacks to share common setup or constraints between actions.
  def set_form
    @form = Form.find(params[:id])
  end

  def form_params
    params.require(:form).permit()
  end
end