# TextField uses base class and extends it with min, max values 
# based on characters or words.  
class TextField < Field
  # set the table name to use a different table than the parent class
  self.table_name = 'text_fields'

  # set enums
  enum format: { 'Characters' => 0, 'Words' => 1 }
end
