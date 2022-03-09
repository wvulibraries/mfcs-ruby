# app/jobs/converting_file_job.rb

# Converting File Job
class ConvertingFileJob < ApplicationJob
  queue_as :default

  def perform(media_id)
    # gets the media (should be the working copy of the item), item and form
    media = Media.find(media_id)
    form = Form.find(media.form_id)
    Conversion::Actor.new(media.id, form.organized_hash[media.fieldname]).perform
  end
end
