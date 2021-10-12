require 'json'
require 'active_support/inflector' 

def update_key(name)
    @hash[name.to_s.underscore] = @hash.delete(name)
end

data_directory = 'importing/watermarks/data' 

Dir.glob(File.join(data_directory, '**', '*.json')).each do |file|
  next if File.directory?(file) # skip the loop if the file is a directory
  puts file

  @hash = JSON.parse(File.read(file))
  next if @hash == false

  array = @hash.keys
  array.each { |key| self.update_key(key) }
  w = Watermark.new(@hash)
  w.image.attach(io: File.open(data_directory + '/images/' + @hash['name'] + '.png'), filename: @hash['name'] + '.png', content_type: "image/png")

  w.save(validate: false)
end

# force reset for id sequence on table since we are importing.
ActiveRecord::Base.connection.reset_pk_sequence!('watermarks')

