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
    @command << "#{ffmpeg_path} -y -i #{@file}"
    instance_eval(&block) if block
    @command << @to_file.to_s
    @command.join(' ')
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
  def size(width, height)
    size = AspectRatio.new(o_height, o_width, width, height)
    width, height = size
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

    system @command
  end
end
