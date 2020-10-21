class Validator::OptionalUrl < Validator::Url
  # Peform function is in all validator classes and returns
  # make the actual validation check to return a boolean.
  #
  # @author David J. Davis
  # @return [Boolean]
  def perform
    @input.blank? || url(@input)
  end
end
