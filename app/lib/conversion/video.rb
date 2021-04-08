# Video Factory
class Conversion::Video < Conversion::Base  

  def self.matches?(mime) 
    mime.split('/')[0].casecmp('video').zero?
  end 

  # Constructor function
  # @params[media] Object call of the media object in the actor class.
  # @params[conversion_params] Hash of the conversion params from the form.
  # @author David J. Davis 
  def initialize(media, conversion_params) 
    @media = media
    @conversion_params = conversion_params
  end 

  # Save file sets the directory and pathname for the conversion
  # also makes sure that the file is changed to the proper format.
  # @author David J. Davis
  # @return [Object]MiniMagick::Image
  def save_file
    @format = (@conversion_params['video_format'] || 'mp4').downcase
    @filename = File.basename(@media.filename, '.*')

    unless File.directory?(@media.item.conversion_path)
      FileUtils.mkdir_p(@media.item.conversion_path)
    end

    @media.item.conversion_path.join("#{@filename}.#{@format}")
  end

  # Saves the media that has been recently converted.
  # @author David J. Davis
  # @return [Object] Media Object
  def perform
    ffmpeg = FFMPEG::Video.new(@media.path, save_file) 
    rate = (@conversion_params['video_bitrate'] || '8M')
    ffmpeg.command do 
      bitrate rate
      size @conversion_params['video_width'], @conversion_params['height']
    end 
    ffmpeg.perform 
    save_media
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