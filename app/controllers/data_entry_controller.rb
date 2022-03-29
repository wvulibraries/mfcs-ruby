# app/controllers/data_entry_controller.rb

# Projects Controller
class DataEntryController < ApplicationController
  # GET /data_entry/select_form
  def index
    breadcrumb 'Select A Form', '/data_entry/select_form', title: 'Select a Form', match: :exact
    @form = Form.object_forms
    @metadata_forms = Form.metadata_forms
  end

  # GET /data_entry/move/:id
  def move
    @item = Item.find(params[:id])
  end

  # GET /data_entry/find/:id
  def find
    @item = Item.find(params[:id])
    @form = Form.find(@item.form_id)
  end

end
