# Basic namespace for Validations.
# This module comes from preset validations existing in the current MFCS system.
# Rails wise this may need some refactoring and moving after the field
# submission logic is created
module Validator
  # Validates that the number is a valid phone number.
  #
  # @example
  #   Validator.handle_type_validation('304.234.2324', 'phone_number') # true
  #
  # @param [String] phone takes a string and validates
  # that it is a phone number.
  #
  # @author David J. Davis
  # @return [Boolean]
  def self.handle_type_validation(input, type)
    validate = {
      phone_number: Validator.phone_number(input),
      ip_addr: Validator.ip(input),
      ip_range: Validator.ip(input),
      url: Validator.url(input),
      optional_url: Validator.optional_url(input),
      email_addr: Validator.email(input),
      internal_email_addr: Validator.email_internal(input),
      integer: Validator.integer(input),
      integer_spaces: Validator.integer_spaces(input),
      alpha: Validator.alpha_spaces(input),
      alpha_no_spaces: Validator.alpha(input),
      alpha_numeric: Validator.alpha_numeric_spaces(input),
      alpha_numeric_no_space: Validator.alpha_numeric(input),
      no_spaces: Validator.no_spaces(input),
      no_special_chars: Validator.no_special_chars(input)
    }.with_indifferent_access

    validate[type]
  end

  def duplications(form_id:, field_name:, reqiured:, no_duplicates:, txt_str:); end

  # Validates that the regular expression matches the statement provided
  #
  # @example
  #   Validator.regex('somestring', '\s') # true
  #   Validator.regex('something cool', '\s') # false
  #
  # @param [String] phone takes a string and validates
  # that it is a phone number.
  #
  # @author David J. Davis
  # @return [Boolean]
  def self.regex(input, regex)
    expression = regex.to_regexp
    input.match?(expression)
  end

  # Validates that a given input matches a given regex
  #
  # @example
  #   Validator.phone_number('304.234.2324') # true
  #
  # @param [String] phone takes a string and validates
  # that it is a phone number.
  #
  # @author David J. Davis
  # @return [Boolean]
  def self.phone_number(phone)
    phone.match?(/\A1?[-. ]?(\(\d{3}\)?[-. ]?|\d{3}?[-. ]?)?\d{3}?[-. ]?\d{4}\z/)
  end

  # Counts the number of words and returns a true or false
  # if the number of words is less than the limit.
  #
  # @example
  #   Validator.limit_words('testing something false', 2) # false
  #   Validator.limit_words('testing something true', 10) # true
  #
  # @param [String] str - The string to evaluate.
  # @param [Integer] limit_number - The limit number max.
  #
  # @author David J. Davis
  # @return [Boolean]
  def self.limit_words(str, limit_number)
    str.split(/\s+/).count <= limit_number
  end

  # Counts the characters in a given string and returns true/false
  # based on an evaluation of the limit and count.
  #
  # @example
  #   Validator.limit_chars('test', 3) # false
  #   Validator.limit_chars('test', 5) # true
  #
  # @param [String] str - The string to evaluate.
  # @param [Integer] limit_number - The limit number max.
  #
  # @author David J. Davis
  # @return [Boolean]
  def self.limit_chars(str, limit_number)
    str.size <= limit_number
  end

  # Validates the string is a proper URL. Accepts telnet, ssh, fpt, https, http.
  #
  # @example
  #   Validator.url('test') # false
  #   Validator.url('https://www.foo.com', 5) # true
  #
  # @param [String] url - The string to evaluate.
  #
  # @author David J. Davis
  # @return [Boolean]
  def self.url(url)
    url.match? %r{\A(http|https|ftp|ssh|telnet)://[a-z0-9@]+([\-.]{1}[a-z0-9]+)*\.[a-z]{2,5}(:[0-9]{1,5})?(/.*)?\z}ix
  end

  # Validates the string is a proper URL or is an empty string.
  #
  # @example
  #   Validator.optional_url('test') # false
  #   Validator.optional_url('http://www.foo.com', 5) # true
  #   Validator.optional_url('') # true
  #
  # @param [String] url - The string to evaluate.
  #
  # @author David J. Davis
  # @return [Boolean]
  def self.optional_url(url)
    url.blank? || self.url(url)
  end

  # Validates that the given param is a valid email. Uses base ruby regex for doing this.
  #
  # @example
  #   Validator.email('test@test.com') # true
  #   Validator.email('test') # false
  #
  # @param [String] address - email address to evaluate.
  #
  # @author David J. Davis
  # @return [Boolean]
  def self.email(address)
    address.match? URI::MailTo::EMAIL_REGEXP
  end

  # Validates the internal email address.
  #
  # @example
  #   Validator.email_internal('test@mail.wvu.edu') # true
  #   Validator.email_internal('test@wvu.edu') # true
  #   Validator.email_internal('test@test.com') # false
  #
  # @param [String] address - email address to evaluate.
  #
  # @author David J. Davis
  # @return [Boolean]
  def self.email_internal(address)
    regex = /.*wvu.edu\z/
    address.match?(regex) && email(address)
  end

  # Uses ruby core class of IPAddress to evaluate valid ip.
  #
  # @example
  #   Validator.ip('192.128.0.12') # true
  #   Validator.ip('192.128.0.260') # false
  #
  # @param [String] address - The ip string to evaluate.
  #
  # @author David J. Davis
  # @return [Boolean]
  def self.ip(address)
    IPAddr.new(address)
    true
  rescue IPAddr::InvalidAddressError
    false
  end

  # Casts the num param as an integer, if errors then returns bool.
  # This will cast to the validator even float point values,
  # however, those are casted as integers and the float point values
  # are dropped. This should be fine for our usecase of determining
  # if the value is an integer for validation.
  #
  # @example
  #   Validator.integer('2') # true
  #   Validator.integer('2a') # false
  #   Validator.integer(3) # true
  #   Validator.integer(3.23445) # true Integer(3.23445) reads as 3
  #
  # @param [String] num - the param to evaluate.
  #
  # @author David J. Davis
  # @return [Boolean]
  def self.integer(num)
    Integer(num)
    true
  rescue ArgumentError, TypeError
    false
  end

  # Pulled part of this from existing MFCS.  The other part validates the number
  # using the integer method in this validation.  The concept here is to allow numbers
  # that have a space in the middle along with other numbers.
  #
  # @example
  #   Validator.integer_spaces(' 2 ') # true
  #   Validator.integer_spaces('02202 235') # true
  #   Validator.integer_spaces(3) # true
  #   Validator.integer_spaces(3.23445) # true Integer(3.23445) reads as 3
  #   Validator.integer_spaces('test) # false
  #
  # @param [String] num - the param to evaluate.
  #
  # @author David J. Davis
  # @return [Boolean]
  def self.integer_spaces(num)
    num.to_s.match?(/\A?\s*[0-9\ ]+\s*\z/) || integer(num)
  end

  # Validates a variety of alpha numerical charactes including spaces.
  #
  # @example
  #   Validator.alpha_numeric('something cool 284') # false
  #   Validator.alpha_numeric('SomethingCool284') # true
  #   Validator.alpha_numeric('SomethingBad2385.') # false
  #
  # @param [String] str - the param to evaluate.
  #
  # @author David J. Davis
  # @return [Boolean]
  def self.alpha_numeric(str)
    str.match?(/\A[a-z0-9]+\Z/i)
  end

  # Validates a variety of alpha numerical charactes including spaces.
  #
  # @example
  #   Validator.alpha_numeric_spaces('something cool 284') # true
  #   Validator.alpha_numeric_spaces('SomethingCool284') # true
  #   Validator.alpha_numeric_spaces('Something Bad 2385.') # false
  #
  # @param [String] str - the param to evaluate.
  #
  # @author David J. Davis
  # @return [Boolean]
  def self.alpha_numeric_spaces(str)
    str.match?(/\A[\sa-z0-9]+\z/i)
  end

  # Alphabetical only with spaces.
  #
  # @example
  #   Validator.alpha('something cool 284') # false
  #   Validator.alpha('SomethingCool284') # true
  #   Validator.alpha('Something Bad 2385.') # false
  #
  # @param [String] str - the param to evaluate.
  #
  # @author David J. Davis
  # @return [Boolean]
  def self.alpha(str)
    str.match?(/\A[a-z]+\z/i)
  end

  # Alphabetical only with spaces.
  #
  # @example
  #   Validator.alpha('SomethingCool284') # true
  #   Validator.alpha('Something Bad 2385') # true
  #   Validator.alpha('Something Bad 2385.') # false
  #
  # @param [String] str - the param to evaluate.
  #
  # @author David J. Davis
  # @return [Boolean]
  def self.alpha_spaces(str)
    str.match?(/\A[\sa-z]+\z/i)
  end

  # Validates that there are no special characters
  #
  # @example
  #   Validator.no_special_chars('#hashtag') # false
  #   Validator.no_special_chars('not hashtag') # true
  #
  # @param [String] str - the string parameter to evaluate.
  #
  # @author David J. Davis
  # @return [Boolean]
  def self.no_special_chars(str)
    str.match?(/\A[a-z0-9\s]+\z/i)
  end

  # Validates as a edtf date.  Edtf will silently fail
  # as nil if the edtf date is not valid. See
  # specs for full examples of valid edtf dates.
  #
  # @example
  #   Validator.date('#hashtag') # false
  #   Validator.date(1984?/2004?~') # true
  #
  # @param [String] str - the string parameter to evaluate.
  #
  # @author David J. Davis
  # @return [Boolean]
  def self.date(date_str)
    !Date.edtf(date_str).nil?
  end

  # Validates that there are no spaces in a given string.
  #
  # @example
  #   Validator.no_spaces('#hashtag') # true
  #   Validator.no_spaces('#hash_tag something really cool') # false
  #
  # @param [String] str - the string parameter to evaluate.
  #
  # @author David J. Davis
  # @return [Boolean]
  def self.no_spaces(str)
    !str.match?(/\s/)
  end
end
