data_directory = 'importing/users' 
count = Dir[File.join(data_directory, '**', '*')].count { |file| File.file?(file) }

puts "Starting import of Users"
Dir.foreach(data_directory) do |filename|
  # skip hidden 
  next if ['.', '..', '.DS_Store'].include?(filename)

  puts "importing #{filename}"

  # parse the data into a new form model
  json_filepath = [data_directory, "/", filename].join

  json = JSON.parse(File.read(json_filepath))

  next if json == false || User.where(id: json['ID']).present?

  # rename fields to match new format
  json['id'] = json['ID']
  json.delete('ID')

  json['first_name'] = json['firstname']
  json.delete('firstname')  

  json['last_name'] = json['lastname']
  json.delete('lastname')
  
  json['student'] = json['isStudent']
  json.delete('isStudent')

  json['form_creator'] = json['formCreator']
  json.delete('formCreator')

  # adjust status
  case json['status']
  when 'Editor'
    json['status'] = 1
  when 'Admin'
    json['status'] = 2
  else
    json['status'] = 0
  end 

  # temporary adjustment for when email address is blank 
  # needs corrected in MFCS (PROD)
  json['email'] = "#{json['username']}@mail.wvu.edu" if json['email'].blank?

  if User.where(email: json['email']).count == 0
      u = User.new(json)
      u.save(validate: false)
  else
      puts "User #{json['email']} already exists"
      # adding id to beginning to insure uniqueness
      json['email'] = "#{json['id']}_#{json['email']}"
  end
end

# force reset for id sequence on table since we are importing.
ActiveRecord::Base.connection.reset_pk_sequence!('users')

