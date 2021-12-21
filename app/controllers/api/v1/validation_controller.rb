# A reboot of the app means we will start from v1 of the API.
# Has many of the same functionality of the old APIs.
# @author David J. Davis
class Api::V1::ValidationController < ApplicationController
  # skips devise
  skip_before_action :authenticate_user!

  # concerns
  include PublicApi
  # include PrivateApi
  # before_action :set_headers,:check_api_key

  # Returns JSON for all forms unless params exist
  # @author David J. Davis
  # @return object[Array <JSON>] Array of form json objects
  def validations
    not_nil_values = %i[form_id fieldname]
    errors = []

    not_nil_values.each do |nnv|
      errors << "#{nnv} is not present and we cannot complete the validation." if params[nnv].blank?
    end

    if errors.present?
      render json: JSON.pretty_generate({ error: errors.join(' ') })
    else
      validate = Validator::Actor.new(params[:form_id], params[:fieldname], params[:input]).perform
      render json: JSON.pretty_generate(validate)
    end
  end
end
