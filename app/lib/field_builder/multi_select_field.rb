# MultiSelect Presenter
# The multiselect presenter will inherit from Select and only change the smallest part needed.
class FieldBuilder::MultiSelectField < FieldBuilder::SelectField
  def html
    hidden = hidden? ? 'hidden hide' : 'show'
    <<-HTML
    <div class="form-field #{@state} #{hidden}">
      <!-- HELP --> 
      #{help_html}
      
      <!-- Label -->
      #{build_label}

      <!-- Input--> 
      <select name="item[data][#{@field['name']}][]" class="#{css_classes} multiselect-select2" id="#{@field['name']}_#{@field['field_id']} #{@field['css_id']}" #{input_options} #{data_attributes} #{html_attributes} multiple> 
      #{options}
      </select>
    </div>
    HTML
  end
end
