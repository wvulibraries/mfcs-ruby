class FieldBuilder::TextareaField < FieldBuilder::TextField
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
      <textarea name="item[data][#{@field['name']}]" class="#{@field['css_class']}" id="#{@field['name']}_#{@field['field_id']}" #{input_options} #{length_validation} #{data_attributes} #{html_attributes}>#{default_value}</textarea>
    </div>
    HTML
  end
end
