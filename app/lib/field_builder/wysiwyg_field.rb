class FieldBuilder::WysiwygField < FieldBuilder::TextField
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
      <input type="hidden" name="item[data][#{@field['name']}]" class="#{@field['css_class']}" id="#{@field['name']}_#{@field['field_id']}" #{input_options} #{data_attributes} #{html_attributes} value="#{default_value}" />

      <!-- Trix Editor --> 
      <trix-editor input="#{@field['name']}_#{@field['field_id']}" data-action="keyup->form-validations#validate change->form-validations#validate" data-name="#{@field['name']}">
      </trix-editor>

      <!-- Feedback --> 
      <div class="feedback"> </div> 

    </div>
    HTML
  end
end
