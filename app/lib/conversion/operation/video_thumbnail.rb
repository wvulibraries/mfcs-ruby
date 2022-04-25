# Operation Class
# Used in Conversion::Video
class Conversion::Operation::VideoThumbnail
  # Matches the thumbnail option is true
  # @author David J. Davis
  # @return [Boolean]
  def self.matches?(params)
    # return false if params are nil
    return false if params.fetch('thumbnail').nil?    

    params.fetch('thumbnail').to_s.casecmp('true').zero?
  end

  # Get values of the params or set defaults
  # @author David J. Davis / Tracy A. McCormick
  # @return [Boolean]
  def initialize(file, params, media_obj)
    @media = media_obj
    @file = file
    @height = params.fetch('thumbnail_height', 300) || 300
    @width = params.fetch('thumbnail_width', 300) || 300
    @resolution = params.fetch('thumbnail_resolution', 72) || 72
    @format = (params.fetch('thumbnail_format', 'jpg') || 'jpg').downcase
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

  # Creates the string for the resolution of the image.
  # @author Tracy A. McCormick
  # @return String Resolution
  def resolution
    @resolution.to_s
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
  # @author(s) David J. Davis / Tracy A. McCormick
  # @abstract
  def perform
    ffmpeg = FFMPEG::Video::Thumbnail.new(@media.path, save_file)
    ffmpeg.command do
      frames 1
      frame_grab
      size @width.to_i, @height.to_i
      disable_audio!
    end
    ffmpeg.perform
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
