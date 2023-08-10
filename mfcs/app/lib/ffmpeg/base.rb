# Base Initializer for the FFMPEG Classes
class Ffmpeg::Base
  # Sets up the instance variables and validates that they are the information needed.
  # @param from_file [String || Pathname]
  # @param options [Hash]
  # @param to_file [String || Pathname] Needs to be the output file and type
  # @author David J. Davis
  def initialize(from_file, to_file, options = {})
    @file = from_file
    @to_file = to_file
    @options = options
    @command = []
    validate!
  end

  # Validates the options param is a hash, or throws an ArgumentError.
  # @author David J. Davis
  def validate!
    [valid_options, valid_file, valid_output].all?
  end

  # Validates the options param is a hash, or throws an ArgumentError.
  # @author David J. Davis
  def valid_options
    return true if @options.is_a?(Hash)

    raise ArgumentError, "Options '#{@options.class}', should be a Hash."
  end

  # Validates the input file exists and is a file as well as that the item is a path or string.
  # @abstract Raises Standard Error.
  # @author David J. Davis
  def valid_file
    return true if path_or_string?(@file) && File.exist?(@file)

    unless path_or_string?(@file)
      raise ArgumentError,
            'Input file should be a type of file, or pathname.'
    end

    raise ArgumentError, 'Input file needs to be a file that exists.'
  end

  # Valid Output Path because without a valid path the commands will fail.
  # @abstract Raises Standard Error.
  # @author David J. Davis
  def valid_output
    return true if path_or_string?(@to_file)

    raise ArgumentError, 'Output Path is a not the correct type and needs to be a path or string.'
  end

  # Path or String is the type that all file and pathnames should be.
  # @return [Boolean]
  # @author David J. Davis
  def path_or_string?(path)
    path.is_a?(String) || path.is_a?(Pathname)
  end

  # Tries to locate the FFmpeg executable only works in Mac/*nix systems.
  # @author David J. Davis
  # @todo (Possibly make work in a broader sense if converting this to a gem.)
  def ffmpeg_path
    `which ffmpeg`.strip
  end

  # Get the filename of the file for use in conversion of something.
  # @author David J. Davis
  # @return [String]
  def filename
    File.basename(@file, '.*')
  end

  # Cross-platform way of finding an executable in the $PATH.
  # which('ruby') #=> /usr/bin/ruby
  # @author ??
  # @see http://stackoverflow.com/questions/2108727/which-in-ruby-checking-if-program-exists-in-path-from-ruby
  # def self.which(cmd)
  #   exts = ENV['PATHEXT'] ? ENV['PATHEXT'].split(';') : ['']
  #   ENV['PATH'].split(File::PATH_SEPARATOR).each do |path|
  #     exts.each do |ext|
  #       exe = File.join(path, "#{cmd}#{ext}")
  #       return exe if File.executable? exe
  #     end
  #   end
  #   raise Errno::ENOENT, "the #{cmd} binary could not be found in #{ENV['PATH']}"
  # end
end
