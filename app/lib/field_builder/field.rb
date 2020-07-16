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
        return (@field['disabled_on_insert'].to_s.downcase == "true" || @field['disabled'].to_s.downcase == "true")
      elsif @state == 'edit' || @state == 'update'
        return (@field['disabled_on_update'].to_s.downcase == "true" || @field['disabled'].to_s.downcase == "true")
      else
        return @field['disabled'].to_s.downcase == "true"
      end
    end

    # Checks that the element is not readonly
    #
    # @example
    #   fb = FieldBuilder::Field.new(field_hash, 'disabled')
    #   fb.readonly? # true
    #
    # @example
    #   fb = FieldBuilder::Field.new(field_hash, 'insert')
    #   fb.readonly? # true || false based on field_hash data
    #
    # @author David J. Davis
    # @return [Boolean]
    def readonly?
      @field['read_only'].to_s.downcase == "true"
    end

    # Checks that the element is not required
    #
    # @example
    #   fb = FieldBuilder::Field.new(field_hash, 'disabled')
    #   fb.required? # true
    #
    # @example
    #   fb = FieldBuilder::Field.new(field_hash, 'insert')
    #   fb.required? # true || false based on field_hash data
    #
    # @author David J. Davis
    # @return [Boolean]
    def required?
      @field['required'].to_s.downcase == "true"
    end

    # Checks that the element is not hidden
    #
    # @example
    #   fb = FieldBuilder::Field.new(field_hash, 'disabled')
    #   fb.hidden? # true
    #
    # @example
    #   fb = FieldBuilder::Field.new(field_hash, 'insert')
    #   fb.hidden? # true || false based on field_hash data
    #
    # @author David J. Davis
    # @return [Boolean]
    def hidden?
      @field['hidden'].to_s.downcase == "true"
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
      options = %w(name label value placeholder)
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

    # Build label information and classes.
    #
    # @example
    #   fb = FieldBuilder::Field.new(field_hash)
    #   fb.build_label
    #
    # @author David J. Davis
    # @return [String] HTML Attributes
    def build_label
      required_class = self.required? ? 'required' : ''
      <<-HTML
        <label for="#{@field['name']}" class="#{required_class}"> #{@field['label']} </label>
      HTML
    end 

    # Uses hash data and helper methods to build out the classes to attach.
    #
    # @example
    #   fb = FieldBuilder::Field.new(field_hash)
    #   fb.classes
    #
    # @author David J. Davis
    # @return [String] CSS classes
    def css_classes 
      classes = []
      classes << "field_#{@field['field_id']}"
      classes << 'disabled' if self.disabled? 
      classes << 'readonly' if self.readonly? 
      classes << 'required' if self.required? 
      classes << @field['css_classes']
      classes.join(' ')
    end  

    # Uses hash data and helper methods to build out the attributes for HTML.
    #
    # @example
    #   fb = FieldBuilder::Field.new(field_hash)
    #   fb.html_attributes
    #
    # @author David J. Davis
    # @return [String] CSS classes
    def html_attributes
      attributes = []
      attributes.push('readonly') if self.readonly?
      attributes.push('disabled') if self.disabled?
      attributes.push('required') if self.required?
      attributes.join(' ') 
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
      hidden = self.hidden? ? 'hidden hide' : 'show'
      <<-HTML
      <div class="form-field #{@state} #{hidden}">
        <!-- Label -->
        #{self.build_label}

        <!-- Input--> 
        <input name="#{@field['name']}" class="#{@field['css_class']}" id="#{@field['css_id']}" #{self.input_options} #{self.data_attributes} disabled="#{self.disabled?}"> 
      </div>
      HTML
    end 
  end

end 