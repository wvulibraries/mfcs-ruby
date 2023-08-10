class AddOcrTextToMedia < ActiveRecord::Migration[6.1]
  def change
    add_column :media, :ocr_text, :text
  end
end
