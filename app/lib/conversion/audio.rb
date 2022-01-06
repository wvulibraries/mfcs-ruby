# app/lib/conversion/audio.rb

# Conversion Audio
# @author(s) David J. Davis, Tracy A. McCormick
class Conversion::Audio < Conversion::Base
  # This provides a interface to the actor class in determining if it needs to fire.
  # @params[mime] String ex: 'image/jpg'
  # @author David J. Davis
  # @return boolean.
  def self.matches?(mime)
    mime.split('/')[0].casecmp('audio').zero?
  end

  # Constructor function
  # @params[media] Object call of the media object in the actor class.
  # @params[conversion_params] Hash of the conversion params from the form.
  # @author(s) David J. Davis / Tracy A. McCormick
  def initialize(media_id, conversion_params)
    @media = Media.find(media_id)
    @conversion_params = conversion_params
  end

  # Save file sets the directory and pathname for the conversion
  # also makes sure that the file is changed to the proper format.
  # @author David J. Davis
  # @return [Object]MiniMagick::Image
  def save_file
    @format = (@conversion_params['audio_format'] || 'mp3').downcase

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
    ffmpeg = FFMPEG::Audio.new(@media.path, save_file)
    rate = (@conversion_params['audio_bitrate'] || '128k')
    ffmpeg.command do
      bitrate rate
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
