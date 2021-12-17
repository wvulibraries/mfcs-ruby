class ProcessFilesJob < ApplicationJob
  queue_as :default

  def perform(item_id, files_hash = {})
    item = Item.find(item_id)
    files_hash.each do |field_name, file_field|
      # insure any old data is cleared from the
      # original mfcs. We will be recreating in
      # the new system
      item[:data][field_name] = []
      item.save

      # queue up each file for processing
      file_field['files']['archive'].each do |file|
        ProcessFileJob.perform_later(item_id, field_name, file)
      end
    end
  end

  #     if field_name != "" && file_field['files']['archive'].present?
  #       # clear existing file info from export
  #       item[:data][field_name] = []
  #       file_field['files']['archive'].each do |file|
  #         # get original_filename
  #         original_filename = file['name']

  #         file_path = find_file(file['path'], original_filename)

  #         if file_path != nil && File.exists?(file_path)
  #           # copy file from the importing directory to the data directory
  #           #self.copy_file(file_path, item.archival_path, original_filename)
  #           #FileCopyJob.perform_later(file_path, item.archival_path, original_filename)

  #           hash = {source_path: file_path, destination_path: item.archival_path, filename: original_filename}
  #           FileCopyJob.perform_later(hash.to_json)

  #           while File.exists?(item.archival_path.join(original_filename)) == false
  #             sleep 1
  #           end

  #           # full path to the file
  #           archive_file_path = item.archival_path.join(original_filename)

  #           hash_values = {
  #             item_id: item.id,
  #             form_id: item.form_id,
  #             media_type: :archive,
  #             filename: original_filename,
  #             path: archive_file_path,
  #             fieldname: field_name
  #           }

  #           # creates archive media object in database
  #           archive_media = Media.new(hash_values)
  #           archive_media.save

  #           item[:data][field_name] << archive_media

  #           item.record_timestamps=false
  #           item.save

  #           # if item.save
  #           #   WorkingFileJob.perform_later(archive_media.id)
  #           # end

  #           # copy file from the importing directory to the data directory
  #           #self.copy_file(file_path, item.working_path, original_filename)
  #           #FileCopyJob.perform_later(file_path, item.working_path, original_filename)
  #           #hash = {source_path: file_path, destination_path: item.working_path, filename: original_filename}
  #           hash[:destination_path] = item.working_path
  #           FileCopyJob.perform_later(hash.to_json)

  #           while File.exists?(item.working_path.join(original_filename)) == false
  #             sleep 1
  #           end

  #           # update hash values for working copy
  #           hash_values[:media_type] = :working
  #           hash_values[:path] = item.working_path.join(original_filename)

  #           # creates archive media object in database
  #           working_media = Media.new(hash_values)
  #           working_media.save

  #           ConvertingFileJob.perform_later(working_media.id)
  #         end
  #       end
  #     end
  #   }
  # end

  # private
end
