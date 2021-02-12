
abort "Nothing to do here" if ARGV.present?

test_img_file = Rails.root.join('data', '1', '0cb76caf', '7bf9', '4928', '8b41', '04242cbf1e02', 'working', 'test_image_3.jpg')

new_img_path = Rails.root.join('data', '1', '0cb76caf', '7bf9', '4928', '8b41', '04242cbf1e02', 'converted')
FileUtils.mkdir_p(new_img_path) unless File.directory?(new_img_path)


MiniMagick::Tool::Convert.new do |convert|
  convert << test_img_file
  convert.bordercolor("#8B008B") # border color must come before border 
  convert.border '10'
  convert.resize '300x300'
  convert.format "png"
  convert << new_img_path.join('test_image_3.png')
end