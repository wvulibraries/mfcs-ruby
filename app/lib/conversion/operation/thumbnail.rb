# Operation Class
# Used in Conversion::Image
class Conversion::Operation::Thumbnail
  # Matches the thumbnail option is true
  # @author David J. Davis
  # @return [Boolean]
  def self.matches?(params)
    params.fetch('thumbnail').to_s.casecmp('true').zero?
  end

  # Get values of the params or set defaults
  # @author David J. Davis
  # @return [Boolean]
  def initialize(file, params, media_obj)
    @media = media_obj
    @file = file
    @height = params.fetch('thumbnail_height') || 300
    @width = params.fetch('thumbnail_width') || 300
    @resolution = params.fetch('thumbnail_resolution') || 72
    @format = (params.fetch('thumbnail_format') || 'jpg').downcase
  end

  # Sets the folder structure up for the file to have thumbnails.
  # @author David J. Davis
  # @abstract
  def thumb_path
    file_path = File.dirname(@file)
    thumb_path = Pathname.new(file_path).join('thumbnail')
    FileUtils.mkdir_p(thumb_path) unless File.exist?(thumb_path)
    thumb_path
  end

  # Creates the interpolated string for the resize of the image.
  # @author David J. Davis
  # @return String "WidthxHeight"
  def size
    "#{@width}x#{@height}"
  end

  # Sets up the save file similarly to how the
  # main image conversion class is setting it.
  # @author David J. Davis
  # @return File Pathname
  def save_file
    @filename = File.basename(@file, '.*')
    thumb_path.join("#{@filename}_thumb.#{@format}")
  end

  # Sets up the save file similarly to how the
  # main image conversion class is setting it.
  # @author David J. Davis
  # @abstract
  def perform
    MiniMagick::Tool::Convert.new do |convert|
      convert << @file
      convert.resize size
      convert.density @resolution
      convert << save_file
    end
    save_media
  end

  # Sets up the save file for thumbnail media
  # @author David J. Davis
  # @abstract
  def save_media
    Media.create(
      form_id: @media.form_id,
      item_id: @media.item_id,
      filename: File.basename(save_file),
      path: save_file,
      media_type: :thumbnail,
      fieldname: @media.fieldname
    )
  end
end
