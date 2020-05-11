# A reboot of the app means we will start from v1 of the API.  
# Has many of the same functionality of the old APIs.    
# @author David J. Davis
class Api::V1::WatermarksController < ActionController::Base
  # concerns
  include PrivateApi
  before_action :set_headers, :check_api_key

  # Returns JSON for all metadata forms   
  # @author David J. Davis
  # @return object[Array <JSON>] Array of form json objects 
  def watermarks
    query = Watermark.select(:id, :name).all.as_json
    render json: JSON.pretty_generate(query)
  end
end 