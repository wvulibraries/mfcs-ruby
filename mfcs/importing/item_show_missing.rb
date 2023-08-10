require 'json'

data_directory = 'importing/objects' 

#Dir.glob(File.join(data_directory, '**', '*.json')).each do |file|
#Dir.glob(File.join(data_directory, '38/**', '*.json')).each do |file| 
#Dir.glob(File.join(data_directory, '71/**', '*.json')).each do |file|   
Dir.glob(File.join(data_directory, '114/**', '*.json')).each do |file| 
  next if File.directory?(file) # skip the loop if the file is a directory

  @hash = JSON.parse(File.read(file))
  if Item.where(id: @hash['ID']).nil?
    puts "Missing item: #{@hash['ID']}"
  end
end