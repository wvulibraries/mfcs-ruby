# Conversion Class for Images
# The parent Conversion::Actor will decide to use the Image, Audio, Video, OCR, and PDF versions.
class Conversion::Image
  # LIST OF POTENTIAL CONVERSION OPTIONS
  # THESE ARE LISTED DURING CONVERSION OPERATIONS
  OPERATIONS = [
    Conversion::Operation::Border,
    Conversion::Operation::Resize,
    Conversion::Operation::Resolution,
    Conversion::Operation::Format
  ].freeze

  # THESE NEED TO HAPPEN AFTER THE CONVERSION
  # ORDER MATTERS, WATERMARK NEEDS TO BE ON THUMB TOO SO
  # THE THUMBNAIL HAPPENS AFTER WATERMARK.
  POST_CONVERSION = [
    Conversion::Operation::WatermarkOverlay,
    Conversion::Operation::Thumbnail
  ].freeze

  # Matcher Class
  # @author David J. Davis
  # @return [Object]MiniMagick::Image
  def self.matches?(mime)
    mime.split('/')[0].casecmp('image').zero?
  end 

  # Initialize sets the instance vars for conversion params and media objects.
  # Runs the Aspect Ratio to keep objects in the correct sizing.
  # Selects Operations that need to run pre conversion.
  # @params[media_id] Media object for the working file.
  # @params[conversion_params] From the form object model should be a hash.
  # @author David J. Davis
  # @abstract
  def initialize(media_id, conversion_params)
    @media = Media.find(media_id)
    @conversion_params = conversion_params

    # set aspect ratio
    orig_width, orig_height = MiniMagick::Image.open(@media.path).dimensions

    width = @conversion_params.fetch('image_width').to_i
    height = @conversion_params.fetch('image_height').to_i
    @conversion_params['image_width'], @conversion_params['image_height'] = AspectRatio.new(orig_width, orig_height, width, height).calculate

    # choose which operations need run
    @operations = OPERATIONS.select { |operation| operation.matches?(@conversion_params) }
  end

  # Save file sets the directory and pathname for the conversion
  # also makes sure that the file is changed to the proper format.
  # @author David J. Davis
  # @return [Object]MiniMagick::Image
  def save_file
    @format = (@conversion_params['image_format'] || 'jpg').downcase
    @filename = File.basename(@media.filename, '.*')
    unless File.directory?(@media.item.conversion_path)
      FileUtils.mkdir_p(@media.item.conversion_path)
    end
    @media.item.conversion_path.join("#{@filename}.#{@format}")
  end

  # Perform the actual conversion, this is an action that does the work set.
  # @author David J. Davis
  # @return [Object]MiniMagick::Image / Truthy
  def perform
    MiniMagick::Tool::Convert.new do |convert|
      convert << @media.path
      @operations.each { |operation| operation.new(@conversion_params).call(convert) }
      convert << save_file
    end
    # save the conversion media object
    media = save_media
    # run post conversion operations Watermarking and Thumbnail Creation
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
