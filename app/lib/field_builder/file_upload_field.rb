# Basic Field Template that all fields will inherit
class FieldBuilder::FileUploadField < FieldBuilder::Field
  def html
    hidden = hidden? ? 'hidden hide' : 'show'
    <<-HTML
      <div class="form-field #{@state} #{hidden}">
        <!-- HELP --> 
        #{help_html}
        
        <!-- Label -->
        #{build_label}

        <!-- Input--> 
        <input type="file" name="item[data][#{@field['name']}]" class="#{css_classes}" id="#{@field['name']} #{@field['css_id']}" #{input_options} #{data_attributes} #{html_attributes} /> 
      </div>
    HTML
  end
end
