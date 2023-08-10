class AddSoftDeleteToMedia < ActiveRecord::Migration[6.1]
  def change
    add_column :media, :soft_delete, :boolean
  end
end
