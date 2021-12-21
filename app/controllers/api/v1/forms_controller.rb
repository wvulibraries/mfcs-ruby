# A reboot of the app means we will start from v1 of the API.
# Has many of the same functionality of the old APIs.
# @author David J. Davis
class Api::V1::FormsController < ApplicationController
  # concerns
  include PrivateApi
  before_action :set_headers, :check_api_key

  # Returns JSON for all forms unless params exist
  # @author David J. Davis
  # @return object[Array <JSON>] Array of form json objects
  def forms
    if params[:id].nil?
      render json: JSON.pretty_generate(Form.all.as_json)
    else
      render json: JSON.pretty_generate(Form.find(params[:id]).as_json)
    end
  end

  # Returns JSON for all metadata forms
  # @author David J. Davis
  # @return object[Array <JSON>] Array of form json objects
  def metadata
    render json: JSON.pretty_generate(Form.metadata_forms.to_json)
  end

  # Returns JSON for all metadata forms, but only returns title, display_title and id.
  # @author David J. Davis
  # @return object[Array <JSON>] Array of form json objects
  def metadata_names
    query = Form.select(:id, :title, :display_title).metadata_forms.as_json
    render json: JSON.pretty_generate(query)
  end

  # Returns JSON for the fields of the selected form
  # MUST BE A FORM PARAM, # FORM MUST HAVE FIELDS
  # @author David J. Davis
  # @return object[Array <JSON>] Array of form json objects
  def field_names
    render json: JSON.pretty_generate({ error: 'The form ID must exist' }) if params[:id].nil?

    fields = Form.find(params[:id]).fields_hash
    field_names = []
    fields.map { |field| field_names << field.slice('name', 'label') }

    render json: JSON.pretty_generate(field_names)
  end
end
