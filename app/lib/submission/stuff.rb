# Basic namespace for Fields
# This will include logic that needs to be done on the Field hashes.
module Submission
  class Stuff
    # Take Item Params and set to Global Varaible so the items can be used.
    # @author David J. Davis
    def initialize(params)
      @params = params.with_indifferent_access
    end

    # Return a hash of the form data so we can establish type.
    # @author David J. Davis
    def form_data
      Form.find(@params[:form_id])
    end
  end
end
