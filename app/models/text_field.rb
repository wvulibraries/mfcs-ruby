# TextField uses base class and extends it with min, max values 
# based on characters or words.  
class TextField < Field
  # set the table name to use a different table than the parent class
  self.table_name = 'text_fields'

  # RAILS CALLBACKS
  # -----------------------------------------------------
  # default values
  after_initialize :set_defaults

  # ENUMERATIONS
  # -----------------------------------------------------
  enum format: { 'Characters' => 0, 'Words' => 1 }

  # PUBLIC METHODS
  # -----------------------------------------------------

  # PRIVATE METHODS
  # -----------------------------------------------------
  private
  # Providing default values for the feild for rendering.
  # @author David J. Davis
  # @abstract
  # @return truthy
  def set_defaults
    # set strings
    self.name ||= 'Untitled'
    self.label ||= 'Untitled'
    # set bools
    self.public_release ||= true
  end
end
