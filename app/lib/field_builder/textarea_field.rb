# Basic namespace for Fields
# This will include logic that needs to be done on the Field hashes.
module FieldBuilder
  # Basic Field Template that all fields will inherit
  class TextareaField < Field
    # Textfield Logic for custom variables.
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
      options = %w[name label placeholder readonly]
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
      if @field['min'].present? || @field['max'].present?
        <<-HTML
          data-min="#{@field['min']}" 
          data-max="#{@field['max']}"
          data-format="#{@field['format']}"
          data-validation="text_length"
        HTML
      end
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
        <textarea name="#{@field['name']}" class="#{@field['css_class']}" id="#{@field['css_id']}" #{input_options} #{length_validation} #{data_attributes} disabled="#{disabled?}">
          #{default_value}
        </textarea>
      </div>
      HTML
    end
  end
end
