require 'json'
require 'active_support/inflector' 

def update_key(name)
    @hash[name.to_s.underscore] = @hash.delete(name)
end

data_directory = 'importing/projects' 

Dir.glob(File.join(data_directory, '**', '*.json')).each do |file|
  next if File.directory?(file) # skip the loop if the file is a directory
  puts "importing #{file}"

  @hash = JSON.parse(File.read(file))
  next if @hash == false

  # rename item
  @hash['name'] = @hash['projectName']
  @hash.delete('projectName')
  
  # delete fields do not see how they are being used currently  
  @hash.delete('forms')
  @hash.delete('groupings')
  @hash.delete('numbering')
  @hash.delete('users')

  array = @hash.keys
  array.each { |key| self.update_key(key) }
  puts @hash.inspect
  p = Project.new(@hash)

  p.save(validate: false)
end

# force reset for id sequence on table since we are importing.
ActiveRecord::Base.connection.reset_pk_sequence!('projects')