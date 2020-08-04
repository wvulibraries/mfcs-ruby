# Basic namespace for Fields
# This will include logic that needs to be done on the Field hashes.
module FieldBuilder
  # Presenter provides the proper class for each individual processed field.
  # @abstract
  # @param field [Hash] containing the parsed json from the form builder.
  # @param state [String] only ['insert', 'update', 'disabled', 'preview', 'create', 'edit']
  # @param current_user which comes form the view helper for Devise.
  # @author David J. Davis
  class Presenter
    FIELD_TYPES = {
      idno: FieldBuilder::IdnoField,
      text: FieldBuilder::TextField,
      textarea: FieldBuilder::TextareaField,
      number: FieldBuilder::NumberField,
      select: FieldBuilder::SelectField,
      multiselect: FieldBuilder::MultiSelectField,
      wysiwyg: FieldBuilder::WysiwygField,
      file: FieldBuilder::FileUploadField
    }.with_indifferent_access.freeze

    # Sets values that will be passed to the smaller field builder presenters.
    # @abstract
    # @author David J. Davis
    def initialize(field, current_user, state = 'disabled')
      @fields = field
      @state = state
      @user = current_user
    end

    # Calls / Returns Proper classes for the field types.
    # Utilizes a constant hash of specified types to make the calls.
    # Rescues from a StandardError if the hash key does not exist.
    # @abstract
    # @author David J. Davis
    def type
      FIELD_TYPES[@fields['type']].new(@fields, @user, @state)
    rescue StandardError => e
      "Field type not recognized, #{e}."
    end
  end
end
