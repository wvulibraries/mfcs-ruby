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

    # hash = {source_path: media.path, destination_path: item.working_path}, filename: media.filename}
    # FileCopyJob.perform_later(hash.to_json)

    working_file = Media.new(media.attributes.merge(id: nil, media_type: :working,
                                                    path: item.working_path.join(media.filename)))
    working_file.save

    # do we need so save the media object back to the item?
    # item[:data][media.fieldname] << working_file
    # item.save

    ConvertingFileJob.perform_later(working_file.id)
    # ProcessingJob.perform_later(working_file.id)
  end
end
