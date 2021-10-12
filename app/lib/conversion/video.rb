# Video Factory
class Conversion::Video < Conversion::Base  

  # THESE NEED TO HAPPEN AFTER THE CONVERSION
  # ORDER MATTERS, WATERMARK NEEDS TO BE ON THUMB TOO SO
  # THE THUMBNAIL HAPPENS AFTER WATERMARK.
  POST_CONVERSION = [
    # Conversion::Operation::VideoImage, ?
    # Conversion::Operation::WatermarkOverlay,
    Conversion::Operation::Thumbnail
  ].freeze

  # This provides a interface to the actor class in determining if it needs to fire.
  # @params[mime] String ex: 'image/jpg' 
  # @author David J. Davis 
  # @return boolean.  
  def self.matches?(mime) 
    mime.split('/')[0].casecmp('video').zero?
  end 

  # Constructor function
  # @params[media_id] Object call of the media object in the actor class.
  # @params[conversion_params] Hash of the conversion params from the form.
  # @author(s) David J. Davis / Tracy A. McCormick
  def initialize(media_id, conversion_params)
    @media = Media.find(media_id)
    @conversion_params = conversion_params
  end 

  # Save file sets the directory and pathname for the conversion
  # also makes sure that the file is changed to the proper format.
  # @author(s) David J. Davis / Tracy A. McCormick
  # @return [Object]MiniMagick::Image
  def save_file
    @format = (@conversion_params['video_format'] || 'mp4').downcase
    @filename = File.basename(@media.filename, '.*')
    @item = Item.find(@media.item_id)
    unless File.directory?(@item.conversion_path)
      FileUtils.mkdir_p(@item.conversion_path)
    end
    @item.conversion_path.join("#{@filename}.#{@format}")
  end

  # Saves the media that has been recently converted.
  # @author(s) David J. Davis / Tracy A. McCormick
  # @return [Object] Media Object
  def perform
    ffmpeg = FFMPEG::Video.new(@media.path, save_file) 
    rate = (@conversion_params['video_bitrate'] || '8M')
    width = @conversion_params.fetch('video_width').to_i 
    height = @conversion_params.fetch('video_height').to_i
    ffmpeg.command do 
      bitrate rate
      size width, height
    end 
    ffmpeg.perform 

    # save the conversion media object
    media = save_media

    # run post conversion operations Thumbnail Creation
    post_conversion = POST_CONVERSION.select { |post_op| post_op.matches?(@conversion_params) }
    post_conversion.each { |post_op| post_op.new(save_file, @conversion_params, media).perform }
  end 

  # Saves the media that has been recently converted.
  # @author David J. Davis
  # @return [Object] Media Object
  def save_media
    Media.create(
      form_id: @media.form_id,
      item_id: @media.item_id,
      filename: File.basename(save_file),
      path: save_file,
      media_type: :conversion,
      fieldname: @media.fieldname
    )
  end
end 