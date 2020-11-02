# Textfield Logic to build the HTML for Text fields.
class FieldBuilder::TextField < FieldBuilder::Field
  # This changes the value of the FieldBuilder variables for Text, Textarea fields.
  #
  # @author David J. Davis
  # @return [String] HTML Attributes
  def default_value
    FieldBuilder::Variable.sub_vars(@field['value'], @user) if @field['value'].present?
  end

  # Build input options that will be for each field semi-dynamically.
  #
  # @author David J. Davis
  # @return [String] HTML Attributes
  def input_options
    html_string = ''
    options = %w[name label placeholder]
    options.each do |option|
      html_string << "#{option}=\"#{@field[option]}\" " unless @field[option].to_s.empty?
    end
    html_string
  end

  # Applies data attributes for things that need to be validated in the form with JavaScript.
  #
  # @author David J. Davis
  # @return [String] HTML Attributes
  def length_validation
    return unless @field['min'].present? && @field['max'].present?

    <<-HTML
      data-min="#{@field['min']}" 
      data-max="#{@field['max']}"
      data-format="#{@field['format']}"
      data-validation="text_length"
      data-action="keyup->form-validations#textLength"
    HTML
  end

  # HTML strings that help to build each field, this method should be over-written,
  # but provides a baseline template.
  #
  # @author David J. Davis
  # @return [String] HTML
  def html
    hidden = hidden? ? 'hidden hide' : 'show'
    <<-HTML
    <div class="form-field #{@state} #{hidden}">
      <!-- HELP --> 
      #{help_html}
  
      <!-- Label -->
      #{build_label}

      <!-- Input--> 
      <input type="text" name="item[data][#{@field['name']}]" class="#{@field['css_class']}" id="#{@field['name']}_#{@field['field_id']}" #{input_options} value="#{default_value}" #{length_validation} #{data_attributes} #{html_attributes}> 

      <div class="feedback"></div> 
    </div>
    HTML
  end
end
