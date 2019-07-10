class CreateUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :users do |t|
      t.string :first_name
      t.string :last_name
      t.integer :status
      t.integer :pagination
      t.boolean :student
      t.boolean :active
      t.string :email
      t.boolean :form_creator
      t.timestamps
    end
  end
end
