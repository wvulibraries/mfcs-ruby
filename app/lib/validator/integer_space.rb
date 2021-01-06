class Validator::IntegerSpace < Validator::Integer
  # Peform function is in all validator classes and returns
  # make the actual validation check to return a boolean.
  #
  # @author David J. Davis
  # @return [Boolean]
  def perform
    return true if @input.blank?
    integer_spaces(@input) || integer(@input)
  end

  # Regex to validate the interger and spaces.
  #
  # @param [String] num - the param to evaluate.
  #
  # @author David J. Davis
  # @return [Boolean]
  def integer_spaces(num)
    num.to_s.match?(/^\s*[0-9\ ]+\s*$/)
  end
end
