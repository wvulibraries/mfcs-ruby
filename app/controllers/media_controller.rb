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
    # if params[:id] == -2
    #   send_file(Rails.root.join('app', 'assets', 'images', 'sound-icon.png'), { type: 'image/png', disposition: 'inline' })
    # end

    media = Media.find(params[:id])
    send_file(media.path, { type: media.mime_type, disposition: 'inline' })
  rescue StandardError
    send_file('app/frontend/packs/images/no-image.png',
              { type: 'image/png', disposition: 'inline' })

    # send_file('app/frontend/packs/images/sound-icon.png',
    # { type: 'image/png', disposition: 'inline' })    
  end
end
