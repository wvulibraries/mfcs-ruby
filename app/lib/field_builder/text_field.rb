# Basic namespace for Fields
# This will include logic that needs to be done on the Field hashes.
module FieldBuilder
  # Basic Field Template that all fields will inherit
  class TextField < Field
    def set_value
      # parses variables inside of value context
    end

    def default_value?
      @field['value'].present?
    end
  end
end
