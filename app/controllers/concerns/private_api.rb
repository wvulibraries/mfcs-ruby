

# app/controllers/concerns/private_api.rb
module PrivateApi
  extend ActiveSupport::Concern

  # Set the headers so CORS doesn't get triggered by clients.
  # @author David J. Davis
  # @return object[Array <Integer>] Array of ids to identify the forms.
  def set_headers
    headers['Access-Control-Allow-Origin'] = '*'
    headers['Access-Control-Allow-Methods'] = 'GET'
    headers['Access-Control-Allow-Headers'] = 'Origin, Authorization, Accept, Content-Type'
    headers['Content-Type'] = 'application/json'
  end

  # Check to see if API KEY is present
  # @author David J. Davis
  # @return object[Array <Integer>] Array of ids to identify the forms.
  def check_api_key
    api_key = request.headers['HTTP_API_KEY']
    # if (params[:api_key].nil? && params[:api_key] != ENV['mfcs_api_key']) || (api_key.nil? && api_key != ENV['mfcs_api_key'])
    if (params[:api_key].nil? && params[:api_key] != ENV['mfcs_api_key']) && (api_key.nil? && api_key != ENV['mfcs_api_key'])
      render json: { error: "Invalid API Key, please make sure you have the proper API Key. #{params[:api_key].inspect} || #{api_key.inspect}" }
    end
  end
end
