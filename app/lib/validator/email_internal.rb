# Validates the internal email address.
class Validator::EmailInternal < Validator::Email
  # Peform function is in all validator classes and returns
  # make the actual validation check to return a boolean.
  #
  # @author David J. Davis
  # @return [Boolean]
  def perform
    email_internal(@input) && email(@input)
  end

  # Validates the internal email address.
  #
  # @param [String] address - email address to evaluate.
  #
  # @author David J. Davis
  # @return [Boolean]
  def email_internal(address)
    address.match?(/.*wvu.edu\z/)
  end
end
