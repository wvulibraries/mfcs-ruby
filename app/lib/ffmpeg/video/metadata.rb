class FFMPEG::Video::Metadata
  def initialize(file)
    @file = file
  end

  def fetch
    ffmpeg_params = "-v error -select_streams v:0 -show_entries stream=width,height,duration,bit_rate -print_format json"
    stdout, _stderr, _status = Open3.capture3("#{ffprobe} #{ffmpeg_params} #{@file}")
    JSON.parse(stdout)['streams'][0].with_indifferent_access
  end

  def ffprobe
    `which ffprobe`.strip
  end
end
