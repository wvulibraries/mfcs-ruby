class ProcessFileJob < ApplicationJob
  queue_as :default

  def perform(item_id, field_name, file)
    item = Item.find(item_id)
    # process file

    # get original_filename
    original_filename = file['name']

    # file_path is temporarly using backup copy
    # for some files so they are not in the correct
    # location
    file_path = find_file(file['path'], original_filename)
    return unless !file_path.nil? && File.exist?(file_path)

    # queue up jobs to copy archive and working copies
    # hash = {source_path: file_path, destination_path: item.archival_path, filename: original_filename}
    # FileCopyJob.perform_later(hash.to_json)
    # hash[:destination_path] = item.working_path
    # FileCopyJob.perform_later(hash.to_json)

    # copy file for archive and working copies
    copy_file(file_path, item.archival_path, original_filename)
    # self.copy_file(file_path, item.working_path, original_filename)

    # full path to the file
    archive_file_path = item.archival_path.join(original_filename)

    hash_values = {
      item_id: item.id,
      form_id: item.form_id,
      media_type: :archive,
      filename: original_filename,
      path: archive_file_path,
      fieldname: field_name
    }

    # creates archive media object in database
    archive_media = Media.new(hash_values)
    archive_media.save

    # add archive media to item
    item[:data][field_name] << archive_media

    # save updated item
    item.record_timestamps = false
    item.save

    WorkingFileJob.perform_later(archive_media.id)

    # update hash_values for working copy
    # hash_values[:media_type] = :working
    # hash_values[:path] = item.working_path.join(original_filename)

    # creates working media object in database
    # working_media = Media.new(hash_values)
    # working_media.save

    # convert media from working copy
    # ConvertingFileJob.perform_later(working_media.id)
  end

  private

  # method is used to find the file in the backup copy
  # temporarly using the backup copy for testing
  # will be removed later
  def find_file(_file_path, _original_filename)
    if File.exist?("importing/objects/#{file_path}/#{original_filename}")
      "importing/objects/#{file_path}/#{original_filename}"
    # don't have all the files yet, so using the backup copy
    elsif File.exist?("importing/objects/folklife_1605711112/archive/#{original_filename}")
      "importing/objects/folklife_1605711112/archive/#{original_filename}"
    end
  end

  def copy_file(from_path, to_path, filename)
    # create the path if it doesn't exist
    FileUtils.mkdir_p(to_path) unless File.directory?(to_path)

    # creates the saved file
    file_path = to_path.join(filename)

    # only copy the original archive file
    FileUtils.cp from_path, file_path
  end
end
