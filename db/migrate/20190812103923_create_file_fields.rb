class CreateFileFields < ActiveRecord::Migration[5.2]
  def change
    create_table :file_fields do |t|
      t.string :name
      t.string :label
      t.string :value
      t.string :css_id
      t.string :css_class
      t.string :local_styles
      t.string :help_type
      t.string :help_info
      t.string :type
      t.boolean :required
      t.boolean :no_duplicates
      t.boolean :read_only
      t.boolean :disabled
      t.boolean :disabled_on_insert
      t.boolean :public_release
      t.boolean :oai_release
      t.boolean :sortable
      t.boolean :searchable
      t.boolean :display_in_list
      t.boolean :hidden
      t.integer :format
      t.string :placeholder
      t.integer :position
      t.string :extensions, array: true, default: []
      t.string :image_options, array: true, default: []
      t.string :audio_options, array: true, default: []
      t.string :video_options, array: true, default: []
      t.integer :thumbnail_height
      t.integer :thumbnail_width
      t.string  :thumbnail_format
      t.integer :img_height
      t.integer :img_width
      t.string :img_format
      t.integer :img_dpi
      t.boolean :img_watermark
      t.boolean :img_border
      t.integer :border_height
      t.integer :border_width
      t.string :border_color
      t.integer :watermark_img
      t.string :watermark_location
      t.integer :audio_bitrate
      t.integer :video_bitrate
      t.string :audio_format
      t.string :video_format
      t.timestamps
    end
  end
end
