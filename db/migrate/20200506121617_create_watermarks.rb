class CreateWatermarks < ActiveRecord::Migration[6.0]
  def change
    create_table :watermarks do |t|
      t.string :name
      t.timestamps
    end
  end
end
