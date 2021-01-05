# Basic namespace for Fields
# This will include logic that needs to be done on the Field hashes.
module FieldBuilder
  # Basic Field Template that all fields will inherit
  class NumberField < Field
    # Number Attributes.
    #
    # @author David J. Davis
    # @return [String] HTML Attributes
    def number_attributes
      return unless @field['min_number'].present? && @field['max_number'].present?

      <<-HTML
        min="#{@field['min_number']}" 
        max="#{@field['max_number']}"
        step="#{@field['step']}"
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
        <input type="number" name="item[data][#{@field['name']}]" class="#{css_classes}" id="#{@field['name']} #{@field['css_id']}" #{number_attributes} #{input_options} #{data_attributes} data-action="keyup->form-validations#validate"
        data-name="#{@field['name']}" #{html_attributes} />
        
        <!-- Feedback --> 
        <div class="feedback"> </div>
      </div>
      HTML
    end
  end
end
