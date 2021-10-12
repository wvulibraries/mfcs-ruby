require 'json'
require 'active_support/inflector' 

if Media.where(media_type: :archive).count != Media.where(media_type: :working).count
  puts "Archive and Working copy mismatch - Reprocessing"
  Media.where(media_type: :archive).each do |media|
    if Media.where(media_type: :working, filename: media.filename).count == 0
      puts "Archive: #{media.filename} - Reprocessing"
      puts "Path: #{media.path}"

      WorkingFileJob.perform_later(media.id)
      sleep(rand(1..2))
    end
  end
end 