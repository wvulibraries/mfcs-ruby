# DSL for using the FFMPEG, resulting in a small focused wrapper.
#
# @author David J. Davis
# @since 0.0.0
# @attr [Command] Takes a block and references the from_file and to_file.
#
class FFMPEG::Video < FFMPEG::Base
  # This builds the command from a string
  # @author David J.Davis
  #
  # @param [Block] Passed block will iterate throught the
  # methods building the string needed to exec ffmpeg.
  #
  # @return [String] The string needed to exec FFMPEG.
  def command(&block)
    @command << "#{ffmpeg_path} -hide_banner -loglevel error -y -i #{@file}"
    instance_eval(&block) if block
    @options.each { |key, value| @command << "-#{key} #{value}" }
    @command << @to_file.to_s
    @command.join(' ')
  end

  # Gets metadata form the file.
  # @author David J.Davis
  #
  # @return [Hash]
  def metadata
    @metadata ||= FFMPEG::Video::Metadata.new(@file).fetch
  end

  # Uses a force commend to force the original aspect ratio on the height and width.
  # @author David J.Davis
  #
  # @param [Integer||String] width of the video
  # @param [Integer||String] height of the video
  # @param [String] the ratio either increase or decrease.  Forces aspect ratio and
  # resizes to fit using either an increase or decrease in size.
  #
  # @return [String] The string needed to exec FFMPEG.
  def size(width, height, force_aspect: true)
    if force_aspect
      metadata = self.metadata
      size = AspectRatio.new(metadata[:width], metadata[:height], width, height).calculate
      width, height = size
    end

    @command << "-s #{width}x#{height}"
  end

  # Changes the bit rate of the video.
  # @author David J.Davis
  #
  # @param [Integer||String] the total bit rate needed.
  #
  # @return [String] The string needed to exec FFMPEG.
  def bitrate(rate = '24000')
    @command << "-vb #{rate}"
  end

  # If there is no command, then return quickly with a false statement.
  # Otherwise continue with the command.
  # @author David J. Davis
  # @return [Boolean]
  def perform
    return false if @command.blank?

    system @command.join(' ')
  end
end
