# app/jobs/reprocess_item_job.rb

# Rerocess Item Job
class ReprocessItemJob < ApplicationJob
  queue_as :default

  def perform(item_id)
    # delete converted files
    # delete_converted_items(item_id)

    working_file = Media.where(item_id: item_id, media_type: "working").first
    ConvertingFileJob.perform_later(working_file.id)
  end

  private

  # clear any converted files
  def delete_converted_items(item_id)
    medias = Media.where(item_id: item_id, media_type: "conversion")
    return true if medias.empty?

    medias.each do |media|
      File.delete(media.path)
      media.destroy
    end
  end
end
