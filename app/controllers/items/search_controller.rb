# app/controllers/items/search_controller.rb

# Items Search Controller
class Items::SearchController < ApplicationController
  # GET /items/search
  def index
    @forms = Form.object_forms
  end
end
