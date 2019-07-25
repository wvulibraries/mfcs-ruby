# Basic namespace for Validations.
# This module comes from preset validations existing in the current MFCS system.
# Rails wise this may need some refactoring and moving after the field
# submission logic is created
module Validator

  # Validates that the number is a valid phone number.
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
    !!(phone =~ /^1?[-\. ]?(\(\d{3}\)?[-\. ]?|\d{3}?[-\. ]?)?\d{3}?[-\. ]?\d{4}$/)
  end

  # Counts the number of words and returns a true or false
  # if the number of words is less than the limit.
  #
  # @example
  #   Validator.limit_words('testing something false', 2) # false
  #   Validator.limit_words('testing something true', 10) # true
  #
  # @param [String] str - The string to test.
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
  # @param [String] str - The string to test.
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
  # @param [String] url - The string to test.
  # 
  # @author David J. Davis
  # @return [Boolean]
  def self.url(url)
    !!(url =~ /^(http|https|ftp|ssh|telnet):\/\/[a-z0-9@]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5}(:[0-9]{1,5})?(\/.*)?$/ix)
  end

  # Validates the string is a proper URL or is an empty string.
  #
  # @example
  #   Validator.optional_url('test') # false
  #   Validator.optional_url('http://www.foo.com', 5) # true
  #   Validator.optional_url('') # true
  #
  # @param [String] url - The string to test.
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
  # @param [String] address - email address to test.
  # 
  # @author David J. Davis
  # @return [Boolean]
  def self.email(address)
    !!(address =~ URI::MailTo::EMAIL_REGEXP)
  end

  # Validates the internal email address.
  #
  # @example
  #   Validator.email_internal('test@mail.wvu.edu') # true
  #   Validator.email_internal('test@wvu.edu') # true 
  #   Validator.email_internal('test@test.com') # false 
  #
  # @param [String] address - email address to test.
  # 
  # @author David J. Davis
  # @return [Boolean]
  def self.email_internal(address)
    regex = /.*wvu.edu$/
    !!(address =~ regex) && self.email(address)
  end

  # Uses ruby core class of IPAddress to evaluate valid ip.
  #
  # @example
  #   Validator.ip('192.128.0.12') # true
  #   Validator.ip('192.128.0.260') # false
  #
  # @param [String] address - The ip string to test.
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
  # @param [String] num - the param to test.
  #
  # @author David J. Davis
  # @return [Boolean]
  def self.integer(num)
    Integer(num)
    true
  rescue ArgumentError, TypeError
    false
  end

  ## DOCUMENT ME TOMORROW DAVE
  def self.integer_spaces(num)
    !!(num =~ /^?\s*[0-9\ ]+\s*$/) || self.integer(num)
  end
end