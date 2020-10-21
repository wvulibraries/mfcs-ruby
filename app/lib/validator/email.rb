# Validates that the given param is a valid email.
# Uses base ruby regex for doing this.
# @return [Boolean]
class Validator::Email
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
    email(@input)
  end

  # Validates that the given param is a valid email. Uses base ruby regex for doing this.
  #
  # @param [String] address - email address to evaluate.
  #
  # @author David J. Davis
  # @return [Boolean]
  def email(address)
    address.match? URI::MailTo::EMAIL_REGEXP
  end
end
