class TextareaField < Field
  # set the table name to use a different table than the parent class
  self.table_name = 'textarea_fields'

  # set enums
  enum format: { 'Characters' => 0, 'Words' => 1 }
end
