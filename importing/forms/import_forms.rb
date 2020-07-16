data_directory = 'importing/forms/data' 
count = Dir[File.join(data_directory, '**', '*')].count { |file| File.file?(file) }

Dir.foreach(data_directory) do |filename|
  # skip hidden 
  next if ['.', '..', '.DS_Store'].include?(filename)

  # parse the data into a new form model
  json_filepath = [data_directory, "/", filename].join

  puts json_filepath.inspect
  json = JSON.parse(File.read(json_filepath))
  
  json.delete('permissions')
  json.delete('navigation')
  
  f = Form.new(json)
  f.title = "Untitled #{f.id}" if f.title.nil? || f.title.empty? 
  f.display_title = "Untitled #{f.id}" if f.display_title.nil? || f.title.empty?
  f.idno = json['idno'] unless json['idno'].nil?
  f.fields = json['fields']

  f.save(validate: false)
end

