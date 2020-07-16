# Basic namespace for Fields
# This will include logic that needs to be done on the Field hashes.
module FieldBuilder
  # Checks that the element is not disabled will be used in the HTML value.
  # @abstract
  # @param field [Hash] which is the hash of field info to turn into HTML
  # @param state [String] only ['insert', 'update', 'disabled', 'preview', 'create', 'edit'] 
  # @author David J. Davis
  class IdnoField < Field
    # Checks if IDNO is managed by System
    #
    # @example
    # fb_idno = FieldBuilder::IdnoField.new(field_hash)
    # expect(fb_idno.managed_by_system?).to eq true
    #
    # @author David J. Davis
    # @return [Boolean]
    def managed_by_system?
      @field['managed_by'].to_s.downcase == 'system'
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
      @field['managed_by'].to_s.downcase == 'user' ||  @field['managed_by'].nil?
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
      hidden = self.hidden? ? 'hidden hide' : 'show'
      <<-HTML
      <div class="form-field #{@state} #{hidden}">
        <!-- Label -->
        #{self.build_label}

        <!-- Input--> 
        <input name="#{@field['name']}" class="#{self.css_classes}" id="#{@field['name']} #{@field['css_id']}" #{self.input_options} #{self.data_attributes} #{self.html_attributes} /> 
      </div>
      HTML
    end 

  end
end 