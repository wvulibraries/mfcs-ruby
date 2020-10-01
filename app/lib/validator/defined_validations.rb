class Validator::DefinedValidations < Validator::Base
  # callbacks
  after_initialize :form, :form_field

  # The perform method of all the classes in the Validator Namespace should be
  # the evaluation of the task at hand.
  #
  # @author David J. Davis
  # @return [Boolean]
  def perform
    type = @form_field['validation']
    return true if type.blank?

    if %w[regex regexp].include? type
      send(type, @input, @form_field['validation_regex'])
    else
      send(type, @input)
    end
  end

  # Validates that the regular expression matches the statement provided
  #
  # @param [String] phone takes a string and validates
  # that it is a phone number.
  #
  # @author David J. Davis
  # @return [Boolean]
  def regex(input, regex)
    expression = regex.to_regexp
    input.match?(expression)
  end

  # Validates that a given input matches a given regex
  #
  # @param [String] phone takes a string and validates
  # that it is a phone number.
  #
  # @author David J. Davis
  # @return [Boolean]
  def phone_number(phone)
    phone.match?(/\A1?[-. ]?(\(\d{3}\)?[-. ]?|\d{3}?[-. ]?)?\d{3}?[-. ]?\d{4}\z/)
  end

  # Validates the string is a proper URL. Accepts telnet, ssh, fpt, https, http.
  #
  # @param [String] url - The string to evaluate.
  #
  # @author David J. Davis
  # @return [Boolean]
  def url(url)
    return false if url.blank?

    url.match? %r{\A(http|https|ftp|ssh|telnet)://[a-z0-9@]+([\-.]{1}[a-z0-9]+)*\.[a-z]{2,5}(:[0-9]{1,5})?(/.*)?\z}ix
  end

  # Validates the string is a proper URL or is an empty string.
  #
  # @param [String] url - The string to evaluate.
  #
  # @author David J. Davis
  # @return [Boolean]
  def optional_url(url)
    url.blank? || url(url)
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

  # Validates the internal email address.
  #
  # @param [String] address - email address to evaluate.
  #
  # @author David J. Davis
  # @return [Boolean]
  def email_internal(address)
    regex = /.*wvu.edu\z/
    address.match?(regex) && email(address)
  end

  # Uses ruby core class of IPAddress to evaluate valid ip.
  #
  # @param [String] address - The ip string to evaluate.
  #
  # @author David J. Davis
  # @return [Boolean]
  def ip(address)
    IPAddr.new(address)
    true
  rescue IPAddr::InvalidAddressError
    false
  end

  alias_method 'ip_range', 'ip'
  alias_method 'ip_addr', 'ip'

  # Casts the num param as an integer, if errors then returns bool.
  # This will cast to the validator even float point values,
  # however, those are casted as integers and the float point values
  # are dropped. This should be fine for our usecase of determining
  # if the value is an integer for validation.
  #
  # @param [String] num - the param to evaluate.
  #
  # @author David J. Davis
  # @return [Boolean]
  def integer(num)
    Integer(num)
    true
  rescue ArgumentError, TypeError
    false
  end

  # Pulled part of this from existing MFCS.  The other part validates the number
  # using the integer method in this validation.  The concept here is to allow numbers
  # that have a space in the middle along with other numbers.
  #
  # @param [String] num - the param to evaluate.
  #
  # @author David J. Davis
  # @return [Boolean]
  def integer_spaces(num)
    num.to_s.match?(/^\s*[0-9\ ]+\s*$/) || integer(num)
  end

  # Validates a variety of alpha numerical charactes including spaces.
  #
  # @param [String] str - the param to evaluate.
  #
  # @author David J. Davis
  # @return [Boolean]
  def alpha_numeric(str)
    str.match?(/\A[a-z0-9]+\Z/i)
  end

  # Validates a variety of alpha numerical charactes including spaces.
  #
  # @param [String] str - the param to evaluate.
  #
  # @author David J. Davis
  # @return [Boolean]
  def alpha_numeric_spaces(str)
    str.match?(/\A[\sa-z0-9]+\z/i)
  end

  # Alphabetical only with spaces.
  #
  # @param [String] str - the param to evaluate.
  #
  # @author David J. Davis
  # @return [Boolean]
  def alpha(str)
    str.match?(/\A[a-z]+\z/i)
  end

  # Alphabetical only with spaces.
  #
  # @param [String] str - the param to evaluate.
  #
  # @author David J. Davis
  # @return [Boolean]
  def alpha_spaces(str)
    str.match?(/\A[\sa-z]+\z/i)
  end

  # Validates that there are no special characters
  #
  # @param [String] str - the string parameter to evaluate.
  #
  # @author David J. Davis
  # @return [Boolean]
  def no_special_chars(str)
    str.match?(/^[a-z0-9\s]*$/i)
  end

  # Validates as a edtf date.  Edtf will silently fail
  # as nil if the edtf date is not valid. See
  # specs for full examples of valid edtf dates.
  #
  # @param [String] str - the string parameter to evaluate.
  #
  # @author David J. Davis
  # @return [Boolean]
  def date(date_str)
    !Date.edtf(date_str).nil?
  end

  # Validates that there are no spaces in a given string.
  #
  # @param [String] str - the string parameter to evaluate.
  #
  # @author David J. Davis
  # @return [Boolean]
  def no_spaces(str)
    !str.match?(/\s/)
  end
end
