# Basic namespace for Fields
# This will include logic that needs to be done on the Field hashes.
module FieldBuilder

  # Basic Field Template that all fields will inherit
  class IDNOField < Field
    def managed_by?
      # sees if the field needs to be a hidden item or a text field
    end 

    def html
      # generates html for textfield 
    end 
  end

end 