f_file = Rails.root.join('spec/fixtures/files/test.mov')
t_file = Rails.root.join('tests/data/files/storm.mp4')

ff = FFMPEG::Video.new(f_file, t_file)
command = ff.command do
  size '720', '1024'
  bitrate '18k'
end

puts command.inspect
