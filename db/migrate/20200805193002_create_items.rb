class CreateItems < ActiveRecord::Migration[6.0]
  def change
    create_table :items do |t|
      t.integer :form_id
      t.jsonb :data
      t.boolean :metadata
      t.string :idno
      t.datetime :modified_time
      t.datetime :created_time
      t.integer :modified_by
      t.integer :created_by
      t.boolean :public_release

      t.timestamps
    end
  end
end
