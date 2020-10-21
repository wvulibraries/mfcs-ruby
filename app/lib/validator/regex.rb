# Validates Input Against Form Regex Supplied by Users.
class Validator::Regex
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
    regex(@input, @field_info['validation_regex'])
  end

  # Validates that the regular expression matches the statement provided
  # @param [String] of the input user is testing
  # @param [String] of the regex that is in the form field.
  #
  # @author David J. Davis
  # @return [Boolean]
  def regex(input, regex)
    expression = regex.to_regexp
    input.match?(expression)
  end
end
