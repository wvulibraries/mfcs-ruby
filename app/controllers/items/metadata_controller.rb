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

  def duplicates
    @form = Form.find(params[:form_id])

    metadata_arry = Item.where(form_id: params[:form_id]).pluck(:data)
    titles = metadata_arry.map { |x| x[params[:field_name]] }
                          .sort.chunk { |e| e }
                          .select { |_e, chunk| chunk.size > 1 }
                          .map(&:first)

    @items = Item.where(form_id: params[:form_id])
                 .where('data ->> :field_name IN (:values)', field_name: params[:field_name], values: titles)
                 .order("data ->> ':field_name'")

    if @form.nil? && @items.blank?
      return redirect_to items_metadata_list_path, warning: 'No Items or Form Present for duplication check'
    end

    # do something else
    temp = nil
  end

  def list_for_form
    if params[:form_id] == 'dups'
      return redirect_to items_metadata_list_path, warning: 'No Items or Form Present for duplication check'
    end

    @form = Form.find(params[:form_id])
    @items = Item.where(form_id: params[:form_id])
  end

  # GET /items/metadata/1/edit
  def edit; end

  # POST /items/metadata
  def create
    @item = Item.new(item_params)
    @form = Form.find(item_params[:form_id])

    if @item.valid? && @item.save
      redirect_to '/items/metadata', success: 'Metadata Object was successfully modified.'
    else
      # render the new item
      render :new
    end
  end

  # PATCH/PUT /items/metadata/1
  def update
    @item = Item.new(item_params)
    @form = Form.find(item_params[:form_id])

    if @item.valid? && @item.save
      redirect_to '/items/metadata', success: 'Metadata Object was successfully modified.'
    else
      # render the new item
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
