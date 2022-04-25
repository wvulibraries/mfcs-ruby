# app/jobs/reprocess_item_job.rb

# Rerocess Item Job

class ReprocessItemJob < ApplicationJob
  queue_as :default

  def perform(item_id)
    # get media for Item
    medias = Item.find(item_id).media
    # loop through all media objects
    medias.each do |media|
      # delete converted and thumbnail media objects
      media.destroy if media.media_type.in?([:converted, :thumbnail])
      # create job to process working file
      ConvertingFileJob.perform_later(media.id) if media.media_type == :working
    end
  end 
end
