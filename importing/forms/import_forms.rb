data_directory = 'importing/forms/data' 
count = Dir[File.join(data_directory, '**', '*')].count { |file| File.file?(file) }

# maps the array 
def morph_to_hash(hash)
  return nil if hash.nil? 
  hash.map.with_index { |h, i| [i, h] }.to_h
end 

Dir.foreach(data_directory) do |filename|
  # skip hidden 
  next if ['.', '..'].include?(filename)

  # parse the data into a new form model
  json_filepath = [data_directory, "/", filename].join
  json = JSON.parse(File.read(json_filepath))

  json['fields'] = morph_to_hash json['fields']
  json['permissions'] = morph_to_hash json['permissions']
  json['navigation'] = morph_to_hash json['navigation']

  f = Form.new(json)

  f.title = "Untitled #{f.id}" if f.title.nil? || f.title.empty? 
  f.display_title = "Untitled #{f.id}" if f.display_title.nil? || f.title.empty?
  f.idno = json['idno'] unless json['idno'].nil?

  f.save(validate: false)
end

