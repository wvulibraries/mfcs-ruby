require 'json'

data_directory = 'importing/objects/data' 

Dir.glob(File.join(data_directory, '**', '*.json')).each do |file|
  next if File.directory?(file) # skip the loop if the file is a directory

  puts "importing #{file}"
  @hash = JSON.parse(File.read(file))

  next if @hash == false || @hash['metadata'].to_i == 0 || Item.where(id: @hash['ID']).present?

  ImportJob.perform_later(file)
end

# force reset for id sequence on table since we are importing.
ActiveRecord::Base.connection.reset_pk_sequence!('items')