# Basic Field Template that all fields will inherit
class FieldBuilder::FileUploadField < FieldBuilder::Field
  # Adds multiple to the input element if the muliple field is checked
  # @author(s): David J. Davis, Tracy A. McCormick

  def multiple_files
    'multiple' if @field['multiple_files'].to_s.casecmp('true').zero?
  end

  def allowed_file_types
    "data-allowed-file-types='#{@field['allowed_file_types']}'"
  end

  def display_files_tab?
    begin
      @field['value'].to_a.count > 0
    rescue StandardError => e
      false
    end
  end

  def files_tab
    if display_files_tab?
      <<-HTML        
        <br><a href="javascript:;" onclick="$('#filesTab').click();">Click to view files tab</a>
      HTML
    end
  end

  def html
    hidden = hidden? ? 'hidden hide' : 'show'
    <<-HTML
      <div class="form-field #{@state} #{hidden}">
        <!-- HELP --> 
        #{help_html}
        
        <!-- Label -->
        #{build_label}

        <!-- View Files Tab -->
        #{files_tab}

        <!-- Input--> 
        <input type="file" name="item[data][#{@field['name']}][]" class="#{css_classes}" id="#{@field['name']} #{@field['css_id']}" #{data_attributes} #{allowed_file_types} #{html_attributes} #{multiple_files}
        data-action="change->form-validations#allowedFileTypes"  /> 

        <!-- Feedback --> 
        <div class="feedback"> </div>
      </div>
    HTML
  end
end
