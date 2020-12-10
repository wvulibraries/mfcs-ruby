class ChangeErrorsToFileErrors < ActiveRecord::Migration[6.0]
  def change
    rename_column :media, :errors, :file_errors
  end
end
