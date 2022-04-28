# DSL for using the FFMPEG, resulting in a small focused wrapper.
#
# @author David J. Davis
# @since 0.0.0
# @attr [Command] Takes a block and references the from_file and to_file.
#
class Ffmpeg::Video::Thumbnail < Ffmpeg::Base
  # SAMPLE COMMAND
  # 'ffmpeg -y -i InputFile.FLV -vframes 1 -an -s 400x222 -ss 30 OutputFile.jpg'

  # This builds the command from a string
  # @author David J.Davis
  #
  # @param [Block] Passed block will iterate throught the
  # methods building the string needed to exec ffmpeg.
  #
  # @return [String] The string needed to exec FFMPEG.
  def command(&block)
    # @command = [] # resets in case called multiple times on the instance.
    @command << "#{ffmpeg_path} -hide_banner -loglevel error -y -i #{@file}"
    instance_eval(&block) if block
    @command << @to_file.to_s
    @command.join(' ')
  end

  # Gets metadata form the file.
  # @author David J.Davis
  #
  # @return [Hash]
  def metadata
    @metadata ||= Ffmpeg::Video::Metadata.new(@file).fetch
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
  def size(width, height, force_aspect: true)
    if force_aspect
      metadata = self.metadata
      size = AspectRatio.new(metadata[:width], metadata[:height], width, height).calculate
      width, height = size
    end
    @command << "-s #{width}x#{height}"
  end

  # Grab the frame in the video by a certain time.
  # @author David J.Davis
  #
  # @param [String] '00:00:05' HH:MM:SS
  #
  # @return [Array || @command]
  def frame_grab(time = '00:00:05')
    @command << "-ss #{time}"
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
