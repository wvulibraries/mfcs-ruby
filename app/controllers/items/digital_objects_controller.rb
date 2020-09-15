class Items::DigitalObjectsController < ApplicationController
  before_action :set_items_digital_object, only: [:show, :edit, :update, :destroy]

  # GET /items/digital_objects
  def index
    @items_digital_objects = Items::DigitalObject.all
  end

  # GET /items/digital_objects/1
  def show
  end

  # GET /items/digital_objects/new
  def new
    @items_digital_object = Items::DigitalObject.new
  end

  # GET /items/digital_objects/1/edit
  def edit
  end

  # POST /items/digital_objects
  def create
    @items_digital_object = Items::DigitalObject.new(items_digital_object_params)

    if @items_digital_object.save
      redirect_to @items_digital_object, notice: 'Digital object was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /items/digital_objects/1
  def update
    if @items_digital_object.update(items_digital_object_params)
      redirect_to @items_digital_object, notice: 'Digital object was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /items/digital_objects/1
  def destroy
    @items_digital_object.destroy
    redirect_to items_digital_objects_url, notice: 'Digital object was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_items_digital_object
      @items_digital_object = Items::DigitalObject.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def items_digital_object_params
      params.fetch(:items_digital_object, {})
    end
end
