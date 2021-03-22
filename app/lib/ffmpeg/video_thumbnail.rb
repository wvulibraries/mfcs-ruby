# DSL for using the FFMPEG, resulting in a small focused wrapper.
#
# @author David J. Davis
# @since 0.0.0
# @attr [Command] Takes a block and references the from_file and to_file.
#
class FFMPEG::VideoThumbnail < FFMPEG::Base
  # SAMPLE COMMAND
  # 'ffmpeg -i InputFile.FLV -vframes 1 -an -s 400x222 -ss 30 OutputFile.jpg'

  # This builds the command from a string
  # @author David J.Davis
  #
  # @param [Block] Passed block will iterate throught the
  # methods building the string needed to exec ffmpeg.
  #
  # @return [String] The string needed to exec FFMPEG.
  def command(&block)
    @command << "#{ffmpeg_path} -i #{@file}"
    instance_eval(&block) if block
    @command << @to_file.to_s
    @command.join(' ')
  end

  # Default number of frames, but setup to be possibly better in the future.
  # @author David J.Davis
  #
  # @param [num] sets up the number of virtual frames that will be captured.
  #
  # @return [Array || @command]
  def frames(num = 1)
    @command << "-vframes #{num}"
  end

  # Forces the audio to be disabled to make process quicker.
  # @author David J.Davis
  #
  # @return [Array || @command]
  def disable_audio!
    @command << '-an'
  end

  # Sets the size of the thumbnail
  # @author David J.Davis
  #
  # @param [Integer||String] width of the thumb
  # @param [Integer||String] height of the thumb
  #
  # @return [Array || @command]
  def size(width, height)
    @command << "-s #{width}x#{height}"
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
