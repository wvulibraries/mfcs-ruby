require 'json'
require 'active_support/inflector' 

if Media.where(media_type: :archive).count != Media.where(media_type: :working).count
  puts "Archive and Working copy mismatch - Reprocessing"
  Media.where(media_type: :archive).each do |media|
    if Media.where(media_type: :working, filename: media.filename).count == 0
      puts "Archive: #{media.filename} - Reprocessing"
      puts "Path: #{media.path}"

      #item = Item.find(media.item_id).first

      # full path to the file
      # working_file_path = item.working_path.join(media.filename) 

      # if not File.exists?(working_file_path)
      #   FileCopyJob.perform_later(media.path, item.working_path, media.filename)

        # FileUtils.mkdir_p(item.working_path) unless File.directory?(item.working_path)
        # FileUtils.cp(media.path, item.working_path) # copies the archive file
      # end
      
      # create a new media record for the working copy
      # working_file = Media.new(media.attributes.merge(id: nil, media_type: :working, path: item.working_path.join(media.filename)))
      # working_file.save

      WorkingFileJob.perform_later(media.id)
    end
  end
end 