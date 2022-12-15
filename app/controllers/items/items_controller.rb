# app/controllers/items_controller.rb

# Items Controller Class
class Items::ItemsController < ApplicationController
  before_action :set_item, only: %i[download_zip]

  # GET /items/1
  def show
    @form = Form.find(@item.form_id)
  end

  ## gets image and shows image
  def thumb
    media = Media.where(item_id: params[:id], media_type: 'thumbnail').first
    file_to_send = media ? { path: media.path, type: media.mime_type } : set_default_image
    send_file(file_to_send[:path], { type: file_to_send[:type], disposition: 'inline' })
  end

  def download_zip
    zip_file = @item.download_all
    send_file(zip_file, { type: 'application/zip', disposition: 'attachment' })
  end

  def download_zip_b
    zip_file = @item.download_all
    send_file(zip_file, { type: 'application/zip', disposition: 'attachment' })
  end

  def download_zip_c
    zip_file = @item.download_all
    send_file(zip_file, { type: 'application/zip', disposition: 'attachment' })
  end

  def download_zip_d
    zip_file = @item.download_all
    send_file(zip_file, { type: 'application/zip', disposition: 'attachment' })
  end

  def download_zip_e
    zip_file = @item.download_all
    send_file(zip_file, { type: 'application/zip', disposition: 'attachment' })
  end

  def download_zip_f
    zip_file = @item.download_all
    send_file(zip_file, { type: 'application/zip', disposition: 'attachment' })
  end

  def download_zip_g
    zip_file = @item.download_all
    send_file(zip_file, { type: 'application/zip', disposition: 'attachment' })
    if zip_file
      if zip_file.exists?
        p 'test' 
        if 1 + 1 == 2
          p 'test'
        end
      else
        p 'other test'
      end
    else
      p 'test'
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_item
    @item = Item.find(params[:id])
  end  

  def set_default_image
    # get the type of item from associated item data
    item = Item.find(params[:id])
    associated_item = Item.find(item.data['type']) 
     # if type is "Collection" or array then must be a collection
    if associated_item.data['type'].eql? "Collection" || item.data['type'].kind_of?(Array)
      return { path: 'app/frontend/packs/images/Documents.svg', type: 'image/svg+xml' }
    elsif associated_item.data['type'].eql? "Sound"
      # return audio image
     return { path: 'app/frontend/packs/images/Audio.svg', type: 'image/svg+xml' }
    elsif associated_item.data['type'].eql? "Video"
      # return video image
      return { path: 'app/frontend/packs/images/Video.svg', type: 'image/svg+xml' }
    elsif associated_item.data['type'].eql? "Image"
      # return image image
      return { path: 'app/frontend/packs/images/Image.svg', type: 'image/svg+xml' }
    elsif associated_item.data['type'].eql? "Text"
      # return pdf image
      return { path: 'app/frontend/packs/images/PDF.svg', type: 'image/svg+xml' }
    end

    # No Image Found
    return { path: 'app/frontend/packs/images/no-image.png', type: 'image/png' }
  end
end
