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

    # Help html method will return strings or nil based on 
    # the values located in the field hash.
    #
    # @example
    #   fb = FieldBuilder::Field.new(field_hash)
    #   fb.help_html
    #
    # @author David J. Davis
    # @return [String] HTML
    def help_html 
      if @field['help_type'].to_i == 3
       <<-HTML
        <a href="#{@field['help_url']}" class="help_url"> 
          <span class='far fa-question-circle field-help'></span>
        </a>
      HTML
      elsif @field['help_type'].to_i == 1 || @field['help_type'].to_i == 2
        title = "#{@field['name']} Help"
        <<-HTML
        <span class="far fa-question-circle field-help" 
              data-toggle="popover" 
              data-trigger="click focus hover" 
              data-html="true" 
              data-content="#{@field['help_info']}" 
              data-original-title="#{title}" 
              title="#{title}">
        </span>
        HTML
      else 
        return nil
      end  
    end 

    # Build input options that will be for each field semi-dynamically.
    #
    # @example
    #   fb = FieldBuilder::Field.new(field_hash)
    #   fb.input_options
    #
    # @author David J. Davis
    # @return [String] HTML Attributes
    def input_options
      html_string = ''
      options = %w(name label value placeholder required read_only hidden)
      options.each { |option| html_string << "#{option}=\"#{@field[option]}\" " unless @field[option].to_s.empty? }
      return html_string
    end 

    # Build data attributes that will be for each field semi-dynamically.
    #
    # @example
    #   fb = FieldBuilder::Field.new(field_hash)
    #   fb.data_attributes
    #
    # @author David J. Davis
    # @return [String] HTML Attributes
    def data_attributes
      html = ''
      attributes = %w(validation validation_regex)
      attributes.each {|attr| html << "data-#{attr}=\"#{@field[attr]}\" " unless @field[attr].to_s.empty? }
      return html 
    end

    # HTML strings that help to build each field, this method should be over-written,
    # but provides a baseline template.
    #
    # @example
    #   fb = FieldBuilder::Field.new(field_hash)
    #   fb.input_options
    #
    # @author David J. Davis
    # @return [String] HTML
    def html 
      <<-HTML
      <div class="form-field #{@state}">
        <label> #{@field['label']} </label>
        <input name="#{@field['name']}" class="#{@field['css_class']}" id="#{@field['css_id']}" #{self.input_options} #{self.data_attributes} disabled="#{self.disabled?}"> 
      </div>
      HTML
    end 
  end

end 