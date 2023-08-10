class AddSoftDeleteToItems < ActiveRecord::Migration[6.1]
  def change
    add_column :items, :soft_delete, :boolean
  end
end
