# app/helpers/items/digital_objects_helper.rb

# Items Digital Objects Helper
module Items::DigitalObjectsHelper
  def save_uploaded_files(item, _item_field, archive_file_path, form_id, form_field)
    files = []
    field.each do |uploaded_file|
      # create the path if it doesn't exist
      FileUtils.mkdir_p(item.archive_path) unless File.directory?(item.archive_path)

      # creates the saved file
      archive_file_path = item.archive_path.join(uploaded_file.original_filename)
      File.open(archive_file_path, 'wb') { |file| file.write(uploaded_file.read) }

      # creates media object in database
      archive_media = create_media(item, form_id, uploaded_file.original_filename,
                                   archive_file_path, form_field)

      files << archive_media.save
    end
  end

  def create_media(item, form_id, filename, archive_file_path, field)
    item.media.build(
      form_id: form_id,
      media_type: :archive,
      filename: filename,
      path: archive_file_path.join(filename),
      fieldname: field
    )
  end
end
