# A reboot of the app means we will start from v1 of the API.
# Has many of the same functionality of the old APIs.
# @author David J. Davis
class Api::V1::ValidationController < ApplicationController
  # concerns
  include PublicApi
  # include PrivateApi
  # before_action :set_headers, :check_api_key

  # Returns JSON for all forms unless params exist
  # @author David J. Davis
  # @return object[Array <JSON>] Array of form json objects
  def validate
    puts params.inspect
    render json: JSON.pretty_generate({ "Something": 'Crazy' })
  end

  def validation_type(type, value); end
end
