# Namespace for classes and modules that handle serving HTML from Field Data Hashes.
# @since 0.0.0
module FieldBuilder
  # Abstract base class for building Field HTML.
  # @author David J. Davis
  # @abstract
  # @since 0.0.0
  class Field
    # Checks that the element is not disabled will be used in the HTML value.
    # @abstract
    # @param field [Hash] which is the hash of field info to turn into HTML
    # @param state [String] only ['insert', 'update', 'disabled', 'preview', 'create', 'edit'] 
    # @author David J. Davis
    def initialize(field, state = 'insert')
      @field = field
      @state = state.downcase

      unless field.is_a?(Hash) 
        raise ArgumentError, 'Field is not a Hash, Field must be a hash to continue.'
      end
    end

    # Checks that the element is not disabled will be used in the HTML value.
    #
    # @example
    #   fb = FieldBuilder::Field.new(field_hash, 'disabled')
    #   fb.disabled? # true
    #
    # @example
    #   fb = FieldBuilder::Field.new(field_hash, 'insert')
    #   fb.disabled? # true || false based on field_hash data
    #
    # @author David J. Davis
    # @return [Boolean]
    def disabled?
      if @state == 'disabled' || @state == 'preview'
        return true
      elsif @state == 'insert' || @state == 'create'
        return !!(@field['disabled_on_insert'] || @field['disabled'])
      elsif @state == 'edit' || @state == 'update'
        return !!(@field['disabled_on_update'] || @field['disabled'])
      else
        return !!@field['disabled']
      end
    end

    def help_html 
      if @field['help_type'].to_i == 3
        return "<a href='#{@field['help_url']}' class='help_url'> <span class='far fa-question-circle field-help'></span> </a>"
      elsif @field['help_type'].to_i == 1 || @field['help_type'].to_i == 2
        title = "#{@field['name']} Help"
        return "<span class='far fa-question-circle field-help' data-toggle='popover' data-trigger='click focus hover' data-html='true' data-content='#{@field['help_info']}' data-original-title='#{title}' title='#{title}'></span>"
      else 
        return nil
      end  
    end 

    def input_options
      # a hash of items to pull from to generate options for html inputs
    end 

    def data_attributes
      # a hash of items to generate data attributes for html inputs
    end
  end

end 