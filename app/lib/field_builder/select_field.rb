# Basic Field Template that all fields will inherit
class FieldBuilder::SelectField < FieldBuilder::Field
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

  # Default Choice that is used to generate manual options
  #
  # @author David J. Davis
  # @return [Boolean]
  def default_option?(opt)
    @field['default_choice'].to_s.casecmp(opt).zero?
  end

  # Manual options will be a string of options to put into the HTML.
  #
  # @author David J. Davis
  # @return [String]
  def manual_options
    options = @field['choice_array'].split(',')
    options_array = []

    options.each do |opt|
      default = default_option?(opt) ? 'selected' : ''
      options_array << "<option value='#{opt}' #{default}> #{opt} </option>"
    end

    options_array.join("\n")
  end

  # Generate the options from another form similar to the way
  # manual options are genrated.
  #
  # @author David J. Davis
  # @return [String]
  def linked_options
    # Get the Items to make into options
    prepped_pluck = ApplicationRecord.sanitize_sql_array(
      ['data->:field_name', { field_name: @field['choice_form_field'] }]
    )
    items = Item.where(form_id: @field['choice_form'].to_i).pluck(Arel.sql(prepped_pluck))

    # Create the list of options
    options = []
    items.each do |item|
      options << "<option value='#{item}'> #{item} </option>"
    end

    options.join("\n")
  end
  
  # Generates the Options in the below HTML dependent on type.
  #
  # @author David J. Davis
  # @return [String]
  def options
    options = []
    options << '<option value=""> Select an Option </option>' if include_null_option?
    options << manual_options if manual?
    options << linked_options if linked?
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
      <select name="item[data][#{@field['name']}]" class="#{css_classes}" id="#{@field['name']} #{@field['css_id']}" #{input_options} #{data_attributes} #{html_attributes}> 
      #{options}
      </select>
    </div>
    HTML
  end
end
