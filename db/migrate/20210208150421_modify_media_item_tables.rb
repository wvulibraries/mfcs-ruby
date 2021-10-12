class ModifyMediaItemTables < ActiveRecord::Migration[6.0]
  def change
    remove_column(:media, :uuid, :string)
    add_column(:items, :uuid, :string) 
    add_column(:media, :media_type, :integer)
  end
end
