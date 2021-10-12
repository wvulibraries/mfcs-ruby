require 'json'

data_directory = 'importing/objects/data' 

#Dir.glob(File.join(data_directory, '**', '*.json')).each do |file|
#Dir.glob(File.join(data_directory, '38/**', '*.json')).each do |file| 
#Dir.glob(File.join(data_directory, '71/**', '*.json')).each do |file|   
Dir.glob(File.join(data_directory, '114/**', '*.json')).each do |file| 
  next if File.directory?(file) # skip the loop if the file is a directory

  @hash = JSON.parse(File.read(file))
  next if @hash == false || Item.where(id: @hash['ID']).present?

  puts file
  ImportJob.perform_later(file)

  #ProcessImportWorker.perform_async(file)
  
  sleep(rand(1..2))
end

# force reset for id sequence on table since we are importing.
ActiveRecord::Base.connection.reset_pk_sequence!('items')