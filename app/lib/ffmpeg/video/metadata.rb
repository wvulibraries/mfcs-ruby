class FFMPEG::Video::Metadata
  def initialize(file)
    @file = file
  end

  def fetch
    stdout, stderr, status = Open3.capture3("#{ffprobe} -v error -select_streams v:0 -show_entries stream=width,height,duration,bit_rate -print_format json #{@file}")
    JSON.parse(stdout)['streams'][0].with_indifferent_access
  end

  def ffprobe
    `which ffprobe`.strip
  end
end
