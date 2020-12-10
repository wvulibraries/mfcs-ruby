class ChangeSizeToString < ActiveRecord::Migration[6.0]
  def change
    change_column :media, :size, :string
  end
end
