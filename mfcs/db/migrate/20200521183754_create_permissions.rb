class CreatePermissions < ActiveRecord::Migration[6.0]
  def change
    create_table :permissions do |t|
      t.belongs_to :user, null: false, foreign_key: true
      t.belongs_to :form, null: false, foreign_key: true
      t.integer :permission
      t.timestamps
    end
  end
end
