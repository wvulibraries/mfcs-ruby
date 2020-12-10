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
    files = item_params['data']['files']

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
