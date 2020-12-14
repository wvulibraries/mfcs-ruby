class Validator::Actor
  # include active model for validations to make error tracking easy
  include ActiveModel::Model
  define_model_callbacks :initialize, only: :after

  # set needed fields
  attr_accessor :field_id, :field_name, :input
  attr_reader :validations

  # after init do this
  after_initialize :form, :form_field

  # validates presence of
  validates :field_id, presence: true, allow_blank: false, allow_nil: false
  validates :field_name, presence: true, allow_blank: false, allow_nil: false
  validates :input, presence: true
  validate :valid_form_object?

  # Sets the inits for instance variables
  # @author David J. Davis
  def initialize(field_id, field_name, input)
    @field_id = field_id
    @field_name = field_name
    @input = input
    run_callbacks :initialize
  end

  # Performs the necessary validations
  # @author David J. Davis
  # @return [Hash] Sets the status and errors for the Hash.
  def perform
    feedback = []
    validation_results = []
    validations = Validator::FieldValidations.new(@form_field).validations.reject(&:blank?)

    validations.each do |validation|
      klass = "Validator::#{validation.classify}".constantize
      instance = klass.new(@input, @form_field, @field_id)
      result = instance.perform
      unless result
        feedback << I18n.t('validator.perform', validated: result, type: validation.titleize, input: @input)
      end
      validation_results << result
    end

    { status: validation_results.reduce(:&), errors: feedback }
  end

  # Rescues from null record error then sends nil back to the validations so
  # validations can be self contained.
  # @author David J. Davis
  # @return [Object] Sets form to an Active Record Object
  def form
    @form = Form.find(@field_id)
  rescue ActiveRecord::RecordNotFound
    @form = nil
  end

  # Form fields from the database to get the values important for validaiton
  # @author David J. Davis
  # @return [Hash] Sets up and Organized Hash from the Active Record
  def form_field
    @form_field ||= @form.organized_hash[@field_name] unless @form.nil?
  end

  # Performs a custom validation to return feedback so the users know what went wrong.
  # @author David J. Davis
  # @return [Boolean]
  def valid_form_object?
    if @form.nil?
      errors[:form_id] << 'Must be a valid form ID.'
      false
    else
      true
    end
  end
end
