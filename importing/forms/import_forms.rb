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
  json_data = JSON.parse(File.read(json_filepath))
  json_data['fields'] = morph_to_hash(json_data['fields'])
  json_data['permissions'] = morph_to_hash(json_data['fields'])
  json_data['navigation'] = morph_to_hash(json_data['fields'])
  json_data['idno'] = morph_to_hash(json_data['idno'])

  f = Form.new(json_data)

  f.title = "Untitled #{f.id}" if f.title.nil? || f.title.empty? 
  f.display_title = "Untitled #{f.id}" if f.display_title.nil? || f.title.empty?
  f.idno = json_data['idno'] unless json_data['idno'].nil?

  if json_data['idno'].nil? && json_data['metadata'] == false
    puts "STOP blank idno field for an object form!"
    break
  end

  # puts f.id.inspect
  # puts f.fields.inspect
  # puts f.valid?
  # break

  # unless json_data['fields'].nil?
  #   fields_hash = {}
  #   json_data['fields'].each_with_index { |h, i| fields_hash[i] = h }
  #   f.fields = fields_hash
  # end

  # unless json_data['permissions'].nil?
  #   permissions_hash = {}
  #   json_data['permissions'].each_with_index { |h, i| permissions_hash[i] = h }
  #   f.permissions = permissions_hash
  # end

  # unless json_data['navigation'].nil?
  #   nav_hash = {}
  #   json_data['navigation'].each_with_index { |h, i| nav_hash[i] = h }
  #   f.navigation = nav_hash
  # end

  f.save(validate: false)
end

