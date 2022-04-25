# Checks that the element is not disabled will be used in the HTML value.
# @abstract
# @param field [Hash] which is the hash of field info to turn into HTML
# @param state [String] only ['insert', 'update', 'disabled', 'preview', 'create', 'edit']
# @author David J. Davis
class FieldBuilder::IdnoField < FieldBuilder::Field
  # Checks if IDNO is managed by System
  #
  # @example
  # fb_idno = FieldBuilder::IdnoField.new(field_hash)
  # expect(fb_idno.managed_by_system?).to eq true
  #
  # @author David J. Davis
  # @return [Boolean]
  def managed_by_system?
    @field['managed_by'].to_s.casecmp('system').zero?
  end

  # Checks if IDNO is managed by User
  #
  # @example
  # fb_idno = FieldBuilder::IdnoField.new(field_hash)
  # expect(fb_idno.managed_by_user?).to eq true
  #
  # @author David J. Davis
  # @return [Boolean]
  def managed_by_user?
    @field['managed_by'].to_s.casecmp('user').zero? || @field['managed_by'].nil?
  end

  # HTML strings that help to build each field, this method should be over-written,
  # but provides a baseline template.
  #
  # @example
  #   fb = FieldBuilder::Field.new(field_hash)
  #   fb.input_options
  #
  # @author David J. Davis
  # @return [String] HTML

  def html
    return '' if managed_by_system?

    hidden = hidden? ? 'hidden hide' : 'show'
    <<-HTML
    <div class="form-field #{@state} #{hidden}">
      <!-- HELP --> 
      #{help_html}
      
      <!-- Label -->
      #{build_label}

      <!-- Input--> 
      <input type="text" name="item[data][#{@field['name']}]" class="#{css_classes}" id="#{@field['name']} #{@field['css_id']}" #{input_options} #{data_attributes} data-name="#{@field['name']}" data-action="keyup->form-validations#validate"#{html_attributes} /> 

      <!-- Feedback --> 
      <div class="feedback"> </div>
    </div>
    HTML
  end
end
