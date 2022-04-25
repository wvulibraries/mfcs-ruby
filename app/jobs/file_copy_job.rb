# app/jobs/file_copy_job.rb

# File Copy Job
# Job to create a duplicate of a file
class FileCopyJob < ApplicationJob
  queue_as :default
  require 'json'

  def perform(json_values)
    hash_values = JSON.parse(json_values)
    source_path = hash_values['source_path']
    destination_path = hash_values['destination_path']
    filename = hash_values['filename']

    # create the path if it doesn't exist
    FileUtils.mkdir_p(destination_path) unless File.directory?(destination_path)

    # creates path to the new file
    file_path = "#{destination_path}/#{filename}"

    FileUtils.cp(source_path, file_path)
  end
end
