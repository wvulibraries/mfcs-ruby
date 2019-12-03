class DeleteFieldsTables < ActiveRecord::Migration[5.2]
  def change
    tables = ActiveRecord::Base.connection.tables.select{ |i| i =~ /([A-Za-z])?+\_fields/ }
    tables.each do |t|
      drop_table t
    end
  end
end
