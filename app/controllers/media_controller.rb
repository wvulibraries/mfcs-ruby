# Media Controller Class
class MediaController < ApplicationController
    ## gets image and shows image
    def index
      media = Media.where(id: params[:id]).first
      send_file(media.path, { :type => media.mime_type, :disposition => 'inline' })
    end
  
    ## gets image and shows image
    def thumb
      begin
        media = Media.where(id: params[:id], media_type: 'thumbnail').first
        send_file(media.path, { :type => media.mime_type, :disposition => 'inline' })
      rescue
        send_file('app/frontend/packs/images/no-image.png', { :type => 'image/png', :disposition => 'inline' })
      end
    end

end