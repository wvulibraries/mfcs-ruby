class AdjustEnumsFields < ActiveRecord::Migration[5.2]
  def change
    tables = ActiveRecord::Base.connection.tables.select{ |i| i =~ /([A-Za-z])?+\_fields/ }
    tables.each do |table_name|
      if column_exists? table_name, :help_type
        change_column table_name, :help_type, 'integer USING CAST(help_type AS integer)'
      else
        add_column table_name, :help_type, :integer
      end
    end
  end
end
