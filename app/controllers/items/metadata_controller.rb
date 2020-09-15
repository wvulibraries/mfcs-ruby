class Items::MetadataController < ApplicationController
  before_action :set_item, only: %i[show edit update destroy]
  before_action :set_form, only: %i[new]

  # GET /items/metadata
  def index
    @forms = Form.metadata_forms
  end

  # GET /items/metadata/1
  def show; end

  # GET /items/metadata/new
  def new
    @item = Item.new
    @item.metadata = @form.metadata
    @item.form_id = params[:form_id]
    @item.public_release = @form.export_public
  end

  # # GET /items/metadata/new/
  # def no_form
  #   redirect_to '/items/metadata', notice: 'no metadata form.'
  # end

  def list_for_form
    @form = Form.find(params[:form_id])
    @items = Item.where(form_id: params[:form_id])
  end

  # GET /items/metadata/1/edit
  def edit; end

  # POST /items/metadata
  def create
    @item = Item.new(item_params)

    if @item.save
      redirect_to items_metadata_list_path, success: 'metadata was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /items/metadata/1
  def update
    if @items.update(item_params)
      redirect_to @items, notice: 'metadata was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /items/metadata/1
  def destroy
    @items.destroy
    redirect_to item_url, notice: 'metadata was successfully destroyed.'
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_item
    @items = Item.find(params[:id])
  end

  def set_form
    @form = Form.find(params[:form_id])
  end

  # Only allow a trusted parameter "white list" through.
  def item_params
    params.require(:item).permit(:form_id, :metadata, :public_release, data: {})
  end
end
