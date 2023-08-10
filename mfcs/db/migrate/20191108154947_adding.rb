class Adding < ActiveRecord::Migration[5.2]
  def change
    tables = ['radio_fields', 'check_fields', 'select_fields', 'multi_select_fields']
    tables.each do |table_name|
      if column_exists? table_name, :choice_type
        change_column table_name, :choice_type, :integer
      else
        add_column table_name, :choice_type, :integer
      end
    end
  end
end
