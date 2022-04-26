# app/controllers/media_controller.rb

# Media Controller Class
class MediaController < ApplicationController
  require 'open-uri'

  ## gets image and shows image
  def index
    media = Media.find(params[:id])
    send_file(media.path, { type: media.mime_type, disposition: 'inline' })
  end

  def image
    media = Media.find(params[:id])
    send_file(media.path, { type: media.mime_type, disposition: 'inline' })
  end  

  ## gets image and shows image
  def thumb
    media = Media.find(params[:id])
    send_file(media.path, { type: media.mime_type, disposition: 'inline' })
  rescue StandardError
    send_file('app/frontend/packs/images/no-image.png', { type: 'image/png', disposition: 'inline' })
  end

  ## gets image and shows image
  def audio
    preview_file
  end  

  def original
    download_file  
  end

  def converted
    download_file 
  end

  private

  def preview_file
    media = Media.find(params[:id])
    send_file(media.path, { type: media.mime_type, disposition: 'inline' })
  rescue StandardError
    send_file('app/frontend/packs/images/no-image.png', { type: 'image/png', disposition: 'inline' })
  end

  def download_file
    media = Media.find(params[:id])
    send_file(media.path, { type: media.mime_type, disposition: 'attachment' }) 
  end  

end
