class WorkingFileJob < ApplicationJob
  queue_as :default

  def perform(media_id)
    # gets the media and item
    media = Media.find(media_id)
    item = Item.find(media.item_id)

    raise StandardError unless media.media_type == :working


    working_file = Media.new(
      form_id: item.form_id,
      item_id: item.id,
      media_type: :working,
      filename: media.filename,
      fieldname: media.fieldname,
      path: item.working_path.join(media.filename)
    )
    working_file.file_info
    working_file.save
  end
end
