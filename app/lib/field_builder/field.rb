# Abstract base class for building Field HTML.
# @author David J. Davis
# @abstract
# @since 0.0.0
class FieldBuilder::Field
  # Checks that the element is not disabled will be used in the HTML value.
  # @abstract
  # @param field [Hash] which is the hash of field info to turn into HTML
  # @param state [String] only ['insert', 'update', 'disabled', 'preview', 'create', 'edit']
  # @author David J. Davis
  def initialize(field, user, state = 'insert')
    @field = field
    @state = state.downcase
    @user = user

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
    case @state
    when 'disabled', 'preview'
      true
    when 'insert', 'create'
      (@field['disabled_on_insert'].to_s.casecmp('true').zero? || @field['disabled'].to_s.casecmp('true').zero?)
    when 'edit', 'update'
      (@field['disabled_on_update'].to_s.casecmp('true').zero? || @field['disabled'].to_s.casecmp('true').zero?)
    else
      @field['disabled'].to_s.casecmp('true').zero?
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
    @field['read_only'].to_s.casecmp('true').zero?
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
    @field['required'].to_s.casecmp('true').zero?
  end

  # Checks to see if duplicates are allowed for validation
  #
  # @example
  #   fb = FieldBuilder::Field.new(field_hash, 'insert')
  #   fb.duplicates? #
  #
  # @author David J. Davis
  # @return [Boolean]
  def no_duplicates?
    @field['no_duplicates'].to_s.casecmp('true').zero?
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
    @field['hidden'].to_s.casecmp('true').zero?
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
    if @field['help_type'].to_s == 'help_url'
      <<-HTML
      <a href="#{@field['help_url']}" class="help_url"> 
        <span class='far fa-question-circle field-help'></span>
      </a>
      HTML
    elsif @field['help_type'].to_s.casecmp('plain_text').zero? ||
          @field['help_type'].to_s.casecmp('html_text').zero?
      title = "#{@field['label']} Help"
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
      ''
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
    options = %w[name label value placeholder]
    options.each do |option|
      html_string << "#{option}=\"#{@field[option]}\" " unless @field[option].to_s.empty?
    end
    html_string
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
    attributes = %w[validation validation_regex]
    attributes.each do |attr|
      html << "data-#{attr}=\"#{@field[attr]}\" " unless @field[attr].to_s.empty?
    end
    html
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
    required_class = required? ? 'required' : ''
    <<-HTML
      <label for="#{@field['name']}_#{@field['field_id']}" class="#{required_class}"> #{@field['label']} </label>
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
    classes << 'disabled' if disabled?
    classes << 'readonly' if readonly?
    classes << 'required' if required?
    classes << @field['css_class']
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
    attributes.push('readonly') if readonly?
    attributes.push('disabled') if disabled?
    attributes.push('required') if required?
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
    hidden = hidden? ? 'hidden hide' : 'show'
    <<-HTML
    <div class="form-field #{@state} #{hidden}">
      <!-- Label -->
      #{build_label}

      <!-- Input--> 
      <input name="item[data][#{@field['name']}]" class="#{@field['css_class']}" id="#{@field['name']}_#{@field['field_id']}" #{input_options} #{data_attributes} #{html_attributes}"> 
    </div>
    HTML
  end

  # def length_validation
  #   {
  #     "data-min" => @field['min'].to_s,
  #     "data-max" => @field['max'].to_s,
  #     "data-format" => @field['format'].to_s
  #   }
  # end

  # Performs the necessary validations
  # @author Tracy A. McCormick
  # @return [Hash]
  # def length_validation

  #   # return values in a hash
  #   { data-min => @field['min'].to_s, data-max => @field['max'].to_s, data-format => @field['format'].to_s }
  # end
end
