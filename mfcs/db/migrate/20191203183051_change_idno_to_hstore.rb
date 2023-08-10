class ChangeIdnoToHstore < ActiveRecord::Migration[5.2]
  def change
    remove_column :forms, :idno 
    add_column :forms, :idno, :hstore
  end
end
