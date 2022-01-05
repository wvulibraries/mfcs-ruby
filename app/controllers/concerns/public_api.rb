# app/controllers/concerns/public_api.rb

# Public Api Concern Used in Controllers
module PublicApi
  extend ActiveSupport::Concern
  # Setup a public cors header for the JSON GET Requests.
  # This is for public API Only and used as a before filter.
  # @author David J. Davis
  # @return object[Array <Integer>] Array of ids to identify the forms.
  def public_headers
    headers['Access-Control-Allow-Origin'] = '*'
    headers['Access-Control-Allow-Methods'] = 'GET'
    headers['Access-Control-Allow-Headers'] = 'Origin, Authorization, Accept, Content-Type'
    headers['Content-Type'] = 'application/json'
  end
end
