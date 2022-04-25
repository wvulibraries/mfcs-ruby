# app/controllers/data_entry_controller.rb

# Projects Controller
class DataEntryController < ApplicationController
  # GET /data_entry/select_form
  def index
    breadcrumb 'Select A Form', '/data_entry/select_form', title: 'Select a Form', match: :exact
    @form = Form.object_forms
    @unused_forms = unused_forms
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

  private

  # Returns a list of unused metadata forms 
  # @author Tracy A. McCormick    
  # @return [Array]
  def unused_forms
    used_forms = []
    Form.object_forms.each do |form|
      used_forms.concat(form.linked_forms)
    end
    Form.metadata_forms.find_all { |form| !used_forms.uniq.include?(form.id) }
  end

end
