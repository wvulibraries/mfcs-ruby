# app/jobs/converting_file_job.rb

# Converting File Job
class ConvertingFileJob < ApplicationJob
  queue_as :default

  def perform(media_id)
    working_media = Media.find(media_id)
    form = Form.where(id: working_media.form_id).first
    Conversion::Actor.new(working_media.id, form.organized_hash[working_media.fieldname]).perform    
  end
end
