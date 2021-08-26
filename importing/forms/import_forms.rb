require 'json'
require 'active_support/inflector' 

def update_key(name)
  @hash[name.to_s.underscore] = @hash.delete(name)
end

def update_fields_key(name)
  @fields[name.to_s.underscore] = @fields.delete(name.to_s)
end

def update_field(field)
  field['allowed_file_types'] = field.delete('allowedExtensions') if field['allowedExtensions']
  field['choice_type'] = field.delete('choicesType') if field['choicesType']
  field['choice_null'] = field.delete('choicesNull') if field['choicesNull']
  field['default_choice'] = field.delete('choicesDefault') if field['choicesDefault']  
  field["choice_array"] = field.delete('choicesOptions').join(",") if field['choicesOptions']  
  field['type'] = 'text' if field['type'] == 'url'
  field['image_height'] = field.delete('convertHeight') if field['convertHeight']
  field['image_width'] = field.delete('convertWidth') if field['convertWidth']
  field['image_format'] = field.delete('convertFormat') if field['convertFormat']
  field['image_resolution'] = field.delete('convertResolution') if field['convertResolution']
  field['audio_bitrate'] = field.delete('bitRate') if field['bitRate']
   
  case field['audio_bitrate']
  when "32"
    field['audio_bitrate'] = 700
  when "64"
    field['audio_bitrate'] = 1200 
  when "192"
    field['audio_bitrate'] = 5000
  when "256"
    field['audio_bitrate'] = 12000
  else  
    field['audio_bitrate'] = 2400
  end
  
  # set to the default resolution if thumbnailFormat is set 
  # previous version didn't set the thumbnail_resolution
  field['thumbnail_resolution'] = "72" if field['thumbnailFormat']

  # Update Watermark location to new style
  if field['watermarkLocation']
    case field['watermarkLocation']
    when 'top|left'
      field['watermark_location'] = "NorthWest"
    when 'top|center'
      field['watermark_location'] = "North"
    when 'top|right'
      field['watermark_location'] = "NorthEast"
    when 'middle|left'
      field['watermark_location'] = "West"
    when 'middle|center'
      field['watermark_location'] = "Center"      
    when 'middle|right'
      field['watermark_location'] = "East" 
    when 'bottom|left'
      field['watermark_location'] = "SouthWest"
    when 'bottom|center'
      field['watermark_location'] = "South"
    when 'bottom|right'
      field['watermark_location'] = "SouthEast"
    end

    # delete old watermark location
    field.delete('watermarkLocation')
  end

  # convert boolean string values to actual boolean values
  # convert empty strings to nil
  field.each do |key, value|
    if value == 'true'
      field[key] = true
    end

    if value == 'false'
      field[key] = false
    end

    if value.blank?
      field[key] = nil
    end
  end

  # temporary settings testing features
  # field['watermark'] = false
  # field['ocr'] = true
  field
end


data_directory = 'importing/forms/data' 
count = Dir[File.join(data_directory, '**', '*.json')].count { |file| File.file?(file) }

Dir.foreach(data_directory) do |filename|
  # skip hidden 
  next if ['.', '..', '.DS_Store'].include?(filename)

  # parse the data into a new form model
  json_filepath = [data_directory, "/", filename].join

  @hash = JSON.parse(File.read(json_filepath))
  
  permissions = @hash['permissions']
  @hash.delete('permissions')
  @hash.delete('navigation')

  # rename items
  @hash['object_public_release_show'] = @hash['objPublicReleaseShow']
  @hash.delete('objPublicReleaseShow') 
  
  @hash['object_public_release_default'] = @hash['objPublicReleaseDefaultTrue']
  @hash.delete('objPublicReleaseDefaultTrue') 

  array = @hash.keys
  array.each { |key| self.update_key(key) }

  @hash['fields'].each { |field|
    @fields = update_field(field)
    array = @fields.keys
    array.each { |key| self.update_fields_key(key) }
    field = @fields
  }

  f = Form.new(@hash)

  f.title = "Untitled #{f.id}" if f.title.nil? || f.title.empty? 
  f.display_title = "Untitled #{f.id}" if f.display_title.nil? || f.title.empty?
  f.idno = @hash['idno'] unless @hash['idno'].nil?
  f.fields = @hash['fields']

  f.save(validate: false)

  # Save Permissions on Form
  if permissions
    permissions.each do |permission|
      # adjust permission
      case permission['type'].to_i
      when 1
        type = "creator"
      when 2
        type = "viewer"
      when 3
        type = "admin"
      else 4
        type = "contact"
      end 

      p = Permission.new({permission: type, form_id: f.id, user_id: permission['userID']})
      p.save
    end
  end
end

# force reset for id sequence on table since we are importing.
ActiveRecord::Base.connection.reset_pk_sequence!('forms')