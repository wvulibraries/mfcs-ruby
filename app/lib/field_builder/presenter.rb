# Basic namespace for Fields
# This will include logic that needs to be done on the Field hashes.
module FieldBuilder
  # Presenter
  class Presenter
    def initialize(field, state = 'disabled', current_user)
      @fields = field
      @state = state
      @user = current_user
    end

    def type
      case @fields['type']
      when 'idno'
        FieldBuilder::IdnoField.new(@fields, @state, @user)
      when 'text'
        FieldBuilder::TextField.new(@fields, @state, @user)
      when 'textarea'
        FieldBuilder::TextareaField.new(@fields, @state, @user)
      when 'number'
        FieldBuilder::NumberField.new(@fields, @state, @user)
      when 'select'
        FieldBuilder::SelectField.new(@fields, @state, @user)
      when 'multiselect'
        FieldBuilder::MultiSelectField.new(@fields, @state, @user)
      when 'wysiwyg'
        FieldBuilder::WysiwygField.new(@fields, @state, @user)
      when 'file'
        FieldBuilder::FileUploadField.new(@fields, @state, @user)
      else
        raise ArgumentError, 'Passed field type does not exist'
      end
    end
  end
end
