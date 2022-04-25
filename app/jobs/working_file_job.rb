# app/jobs/working_file_job.rb

# Job to create working file media object from archive file
# media object
class WorkingFileJob < ApplicationJob
  queue_as :default

  def perform(media_id)
    # gets the media and item
    media = Media.find(media_id)
    item = Item.find(media.item_id)

    FileUtils.mkdir_p(item.working_path) unless File.directory?(item.working_path)
    unless File.exist?(item.working_path.join(media.filename))
      FileUtils.cp(media.path,
                   item.working_path)
    end

    working_media = Media.new(media.attributes.merge(id: nil, media_type: :working,
                                                    path: item.working_path.join(media.filename)))
    working_media.save

    ConvertingFileJob.perform_later(working_media.id)
  end
end    