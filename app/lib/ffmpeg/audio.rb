# DSL for using the FFMPEG, resulting in a small focused wrapper.
#
# @author David J. Davis
# @since 0.0.0
# @attr [Command] Takes a block and references the from_file and to_file.
#
class FFMPEG::Audio < FFMPEG::Base
  # This builds the command from a string
  # @author David J.Davis
  #
  # @param [Block] Passed block will iterate throught the
  # methods building the string needed to exec ffmpeg.
  #
  # @return [String] The string needed to exec FFMPEG.
  def command(&block)
    @command << "#{ffmpeg_path} -hide_banner -loglevel error -y -i #{@file}"
    normalize
    instance_eval(&block) if block
    @command << @to_file.to_s
    @command.join(' ')
  end

  # Adds to the building of the string.  In pervious versions
  # this is hardcoded, but in future versions this might
  # be an additional interface feature. As of right now
  # user has no way to interact so it is staying hardcoded.
  # @author David J.Davis
  #
  # @return [Array] this adds to the command array, which
  # has not been joined yet.
  def normalize
    @command << '-filter:a loudnorm'
  end

  # Value to pass to the audios bitrate.
  # @author David J.Davis
  #
  # @param [bitrate] integer or string that will go into
  # the string directly.
  #
  # @return [Array] this adds to the command array, which
  # has not been joined yet.
  def bitrate(bitrate)
    @command << "-ab #{bitrate}"
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
