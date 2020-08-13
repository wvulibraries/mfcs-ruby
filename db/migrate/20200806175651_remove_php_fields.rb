class RemovePhpFields < ActiveRecord::Migration[6.0]
  def change
    remove_column :items, :created_time, :datetime
    remove_column :items, :modified_time, :datetime
  end
end
