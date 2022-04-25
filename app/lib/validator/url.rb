# app/lib/validator/url.rb

# Valdiator Url
class Validator::Url
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

    url(@input)
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
end
