# Basic namespace for Fields
# This will include logic that needs to be done on the Field hashes.
module FieldBuilder
  # Basic Field Template that all fields will inherit
  class SelectField < Field
    # Managed by Manual Options or Linked to another form.
    #
    # @author David J. Davis
    # @return [Boolean]
    def manual?
      @field['choice_type'].to_s.casecmp('manual').zero? || @field['choice_type'].to_s.empty?
    end

    # Managed by Manual Options or Linked to another form.
    #
    # @author David J. Davis
    # @return [Boolean]
    def linked?
      @field['choice_type'].to_s.casecmp('link_to_form').zero?
    end

    # See if it includes a null option
    #
    # @author David J. Davis
    # @return [Boolean]
    def include_null_option?
      ActiveModel::Type::Boolean.new.cast(@field['choice_null']).to_s == 'true'
    end

    def default_option?(opt)
      @field['default_choice'].to_s.casecmp(opt).zero?
    end

    def manual_options
      options = @field['choice_array'].split(',')
      options_array = []

      options.each do |opt|
        default = default_option?(opt) ? 'selected' : ''
        options_array << "<option value='#{opt}' #{default}> #{opt} </option>"
      end

      options_array.join("\n")
    end

    def options
      options = []
      options << '<option value=""> Select an Option </option>' if include_null_option?
      options << manual_options if manual?
      options.join('')
    end

    def html
      hidden = hidden? ? 'hidden hide' : 'show'
      <<-HTML
      <div class="form-field #{@state} #{hidden}">
        <!-- HELP --> 
        #{help_html}
        
        <!-- Label -->
        #{build_label}

        <!-- Input--> 
       <select name="#{@field['name']}" class="#{css_classes}" id="#{@field['name']} #{@field['css_id']}" #{input_options} #{data_attributes} #{html_attributes}> 
        #{options}
       </select>
      </div>
      HTML
    end
  end
end
