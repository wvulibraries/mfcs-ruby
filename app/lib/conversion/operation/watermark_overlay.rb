# Operation Class
# Used in Conversion::Image
class Conversion::Operation::WatermarkOverlay
  # Matches the watermark is a true statement
  # determines that the post operation of watermark creation should take place.
  # @author David J. Davis
  # @return [Boolean]
  def self.matches?(params)
    params.fetch('watermark').to_s.casecmp('true').zero?
  end

  # Init Function
  # Location Choices: NorthWest, North, NorthEast,
  # West, Center, East, SouthWest, South, SouthEast
  # @params[file_path] This is the file that has had the conversion already done.
  # @params[params] These are the params from the form object model.
  # @author David J. Davis
  # @abstract
  def initialize(file_path, params, media_obj)
    @media = media_obj
    @file_path = file_path
    @watermark_id = (params.fetch('watermark_image') || nil)
    @location = (params.fetch('watermark_location') || 'SouthWest')
  end

  # Grabs the image by watermark, if no watermark is returned for the supplied ID,
  # use the last watermark made.
  # @author David J. Davis
  # @return [Object]MiniMagick::Image
  def watermark_image
    watermark = if Watermark.exists?(@watermark_id)
                  Watermark.find(@watermark_id)
                else
                  Watermark.last
                end
    blob_key = watermark.image.blob.key
    MiniMagick::Image.open(ActiveStorage::Blob.service.path_for(blob_key))
  end

  # Resizes the watermarks based on the original images dimensions
  # @author David J. Davis
  # @return [String]
  def size_the_watermark(dimension)
    width = dimension[0] / 2
    height = dimension[1] / 2
    "#{width}x#{height}"
  end

  # Peforms the minimagick composite and saves the file
  # @note it will never make it to the true if the write fails
  # @author David J. Davis
  # @return truthy
  def perform
    converted_file = MiniMagick::Image.open @file_path
    watermark = watermark_image.resize(size_the_watermark(converted_file.dimensions))
    result = converted_file.composite(watermark) do |image_composite|
      image_composite.compose 'Over' # OverCompositeOp
      image_composite.gravity @location
      image_composite.geometry '+20+20'
    end
    result.write @file_path
    true
  end
end
