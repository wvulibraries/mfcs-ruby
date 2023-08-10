# app/lib/validator/alpha_space.rb

# Validates a variety of alphabetical with spaces.
class Validator::AlphaSpace
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

    @input.match?(/\A[\sa-z]+\z/i)
  end
end
