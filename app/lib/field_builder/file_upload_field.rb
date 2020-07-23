

# Basic namespace for Fields
# This will include logic that needs to be done on the Field hashes.
module FieldBuilder
  # Basic Field Template that all fields will inherit
  class FileUploadField < Field
    def parse_variables
      # parses variables inside of value context
    end

    def input_options
      # overrides defaults to provide a different set of html options
    end

    def html
      # generates html for textfield
    end
  end
end
