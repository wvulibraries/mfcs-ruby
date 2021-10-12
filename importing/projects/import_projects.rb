data_directory = 'importing/projects/data' 
count = Dir[File.join(data_directory, '**', '*')].count { |file| File.file?(file) }

Dir.foreach(data_directory) do |filename|
  # skip hidden 
  next if ['.', '..', '.DS_Store'].include?(filename)

  # parse the data into a new form model
  json_filepath = [data_directory, "/", filename].join

  puts json_filepath.inspect
  json = JSON.parse(File.read(json_filepath))

  json.delete('forms')
  json.delete('groupings')
  json.delete('numbering')
  json.delete('users')

  # rename fields to match new format
  json['id'] = json['ID']
  json.delete('ID')

  json['name'] = json['projectName']
  json.delete('projectName')  

  json['project_id'] = json['projectID']
  json.delete('projectID') 

  p = Project.new(json)

  p.name = "Untitled #{f.id}" if p.name.nil? || p.name.empty? 
  p.save(validate: false)
end

# force reset for id sequence on table since we are importing.
ActiveRecord::Base.connection.reset_pk_sequence!('projects')

