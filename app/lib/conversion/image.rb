class Conversion::Image
  IMAGE_PARAMS = %w[border border_width border_color image_format image_height image_resolution image_width watermark watermark_image watermark_location].freeze

  def initialize(media_id)
    @archived_media = Media.find(media_id)
  end

  def conversion_params
    item ||= @archived_media.item
    item.form.organized_hash[@archived_media.fieldname].select {|key, value| IMAGE_PARAMS.include?(key) }
  end 

  def border? 
    conversion_params['border'].present? && conversion_params['border_width'].present? && conversion_params['border_color'].present?
  end 

  def watermark? 
    conversion_params['watermark'].present? && conversion_params['watermark_image'].present? && conversion_params['watermark_location'].present?
  end 

  def resize? 
    conversion_params['image_width'].present? && conversion_params['image_height'].present?
  end 

  def image_sizing 
    "#{conversion_params['image_width']}x#{conversion_params['image_height']}"
  end 

  def image_name 
    if conversion_params['image_format'].present?
      name = @archived_media.filename.split('.')
      "#{name}.#{conversion_params['image_format']}"
    else
      @archived_media.filename
    end 
  end 

  def perform
    MiniMagick::Tool::Convert.new do |convert|
      convert << test_img_file
      convert.bordercolor conversion_params['border_width'] if border?
      convert.border conversion_params['border_width'] if border?
      convert.resize image_sizing if resize?
      convert.density conversion_params['image_resolution'] if conversion_params['image_resolution'].present?
      convert.format conversion_params['image_format'] if conversion_params['image_format'].present?
      convert << new_img_path.join(image_name)
    end
  end 
end

# class Conversion::Ocr
#   def perform 
#     # takes the image and performs the ocr 
#   end 
# end 

# class Conversion::ImageBase 
#   def border 
#     # creates border 
#   end 

#   def watermark 
#     # creates watermark if needed
#   end 
# end 

# class Conversion::Image < Conversion::ImageBase 
#   def perform 
#     # creates the conversion
#   end 
# end 

# class Conversion::Thumbnail < Conversion::ImageBase 
#   def type
#     # video || image || audio 
#     # if audio just use a supplied image 
#   end
  
#   def perform
#     # create thumbnail size include watermark and border? 
#   end 
# end 

# class Conversion::Video
#   def perform
#     # creates the video conversion 
#   end 
# end 

# class Conversion::CombinePDF
#   def perform 
#     # if image conversion needs done, this should be done first
#     # if multiple files, a pdf will be made of all images compressed into a PDF.
#   end 
# end 

