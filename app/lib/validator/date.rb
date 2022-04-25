# app/lib/validator/date.rb

# Validates as a edtf date.  Edtf will silently fail
# as nil if the edtf date is not valid. See
# specs for full examples of valid edtf dates.
# @author David J. Davis
class Validator::Date
  # Basic constructor for all Validator Methods
  # @author David J. Davis
  def initialize(input, field_info, form_id)
    @field_info = field_info
    @input = input
    @form_id = form_id
  end

  # Peform function is in all validator classes and returns
  # make the actual validation check to return a boolean.
  #
  # @author David J. Davis
  # @return [Boolean]
  def perform
    return true if @input.blank?

    !Date.edtf(@input).nil?
  end
end
