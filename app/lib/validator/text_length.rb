class Validator::TextLength
  # Setup Callbacks and Active Model Features
  include ActiveModel::Model
  define_model_callbacks :initialize, only: :after

  # after init do this
  after_initialize :default_min, :default_max, :format

  # Basic constructor for all Validator Methods
  # @author David J. Davis
  def initialize(input, field_info, form_id)
    @field_info = field_info
    @input = input
    @form_id = form_id
    run_callbacks :initialize
  end

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
    return true if @min == @max

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

  # Default max or form_field column
  # @author David J. Davis
  def default_min
    num = @field_info['min'].presence || 0 unless @field_info.nil?
    @min = num.to_i
  end

  # Default max or form_field column.
  # @author David J. Davis
  def default_max
    num = @field_info['max'].presence || 30_000 unless @field_info.nil?
    @max = num.to_i
  end

  # Default format or form_field column.
  # @author David J. Davis
  def format
    type = @field_info['format'].presence unless @field_info.nil?
    @format = type || 'characters'
  end
end
