class Validator::TextLength < Validator::Base
  # callbacks
  after_initialize :form, :form_field, :default_max, :default_min, :default_format

  # Provides full validation based on the options in the field hashes
  #
  # @param [String] str - The string to evaluate.
  # @param [Integer] min - If min is not provided then it is set to 0
  # @param [Integer] max - If max is not provided then it is set to 30000
  # @param [String] format - should be characters or words, but could expand to more.
  #
  # @author David J. Davis
  # @return [Boolean]
  def perform
    if %w[words word].include? @format
      word_limits(@input, @min, @max)
    else
      character_limits(@input, @min, @max)
    end
  end

  # Counts the number of characters in a given string then
  # makes sure it is inbetween the min and max values given.
  #
  # @param [String] str - The string to evaluate.
  # @param [Integer] limit_number - The limit number min.
  # @param [Integer] limit_number - The limit number max.
  #
  # @author David J. Davis
  # @return [Boolean]
  def character_limits(str, min, max)
    str.size.between?(min, max)
  end

  # Counts the number of words in a given string then
  # makes sure it is inbetween the min and max values given.
  #
  # @param [String] str - The string to evaluate.
  # @param [Integer] limit_number - The limit number min.
  # @param [Integer] limit_number - The limit number max.
  #
  # @author David J. Davis
  # @return [Boolean]
  def word_limits(str, min, max)
    str.split(/\s+/).count.between?(min, max)
  end

  # Everything below this uses the null operator in ruby.

  # Default max or form_field column
  # @author David J. Davis
  def default_min
    @min = @form_field[:min].presence || 0
  end

  # Default max or form_field column.
  # @author David J. Davis
  def default_max
    @max = @form_field[:max].presence || 30_000
  end

  # Default format or form_field column.
  # @author David J. Davis
  def default_format
    @format = @form_field[:format].presence || 'characters'
  end
end
