class ConvertingFileJob < ApplicationJob
  queue_as :default

  def perform(media_id)
    # gets the media, item and form
    media = Media.find(media_id)
    form = Form.find(media.form_id)
    Conversion::Actor.new(media.id, form.organized_hash[media.fieldname]).perform
  end
end
