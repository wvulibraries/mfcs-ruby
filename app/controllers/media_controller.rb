# app/controllers/media_controller.rb

# Media Controller Class
class MediaController < ApplicationController
  ## gets image and shows image
  def index
    media = Media.find(params[:id])
    send_file(media.path, { type: media.mime_type, disposition: 'inline' })
  end

  ## gets image and shows image
  def thumb
    media = Media.find(params[:id])
    send_file(media.path, { type: media.mime_type, disposition: 'inline' })
  rescue StandardError
    send_file('app/frontend/packs/images/no-image.png',
              { type: 'image/png', disposition: 'inline' })
  end
end
