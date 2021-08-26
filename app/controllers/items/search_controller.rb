class Items::SearchController < ApplicationController
  # GET /items/search
  def index
    @forms = Form.object_forms
  end

  private

end
