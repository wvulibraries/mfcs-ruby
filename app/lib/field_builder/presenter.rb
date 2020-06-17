# Basic namespace for Fields
# This will include logic that needs to be done on the Field hashes.
module FieldBuilder
  # Presenter
  class Presenter
    def initialize(field, disabled = false)
      @field = field 
      @disabled = disabled
    end

    def type
      case field['type']
        when 'idno'
          IDNOField.new(@field, @disabled)
        when 'text'
          TextField.new(@field, @disabled)
        when 'textarea'
          TextareaField.new(@field, @disabled)
        when 'number'
          NumberField.new(@field, @disabled)
        when 'select'
          SelectField.new(@field, @disabled)
        when 'multiselect'
          MultiSelectField.new(@field, @disabled) 
        when 'wysiwyg'
          WysiwigField.new(@field, @disabled)
        when 'file'
          FileUploadField.new(@field, @disabled)
        else
          raise ArgumentError, 'Passed field type does not exist'
        end
      end  
    end 
  end
end