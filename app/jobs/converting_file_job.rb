class ConvertingFileJob < ApplicationJob
  queue_as :default

  def perform(media_id)
    # gets the media and item
    media = Media.find(media_id)
    item = Item.find(media.item_id)
  end
end
