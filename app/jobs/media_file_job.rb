class MediaFileJob
  queue_as :default

  def perform(json_values)
    hash_values = JSON.parse(json_values)

    # gets the item
    item = Item.find(hash_values[item_id])

    # FileUtils.mkdir_p(item.archive_path) unless File.directory?(item.archive_path)
    # FileUtils.cp(hash_values[file_path], item.archive_path) # copies the archive file

    #### Testing file copy Job
    # hash = {
    #  to_path: hash_values[path],
    #  from_path: hash_values[file_path]
    # }

    # copy file to archival directory
    # FileCopyJob.perform_later(hash.to_json)

    #   hash = {
    #     item_id: hash_values[item_id],
    #     form_id: hash_values[form_id],
    #     media_type: hash_values[media_type],
    #     filename: hash_values[filename],
    #     path: hash_values[path],
    #     fieldname: hash_values[fieldname]
    #  }

    #   puts hash.inspect

    # archive_file = Media.new(hash)
    # puts "Create Archive Media Object"
    # puts archive_file.inspect

    # archive_file.file_info
    # archive_file.save
    # puts "Save Archive Media Object"
    # puts archive_file.inspect

    # do we need so save the media object back to the item?
    # item[:data][archive_file.fieldname] << archive_file
    # item.save

    # ConvertingFileJob.perform_later(working_file.id)
    # ProcessingJob.perform_later(working_file.id)
  end
end
