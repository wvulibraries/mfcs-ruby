#!/bin/env ruby

class Import
  require 'json'

  def initialize
    #puts 'This will import the export from mfcs(prod) into the new mfcs(ruby) ... are you sure you want to do this? (Yes, No)'
    perform
  end

  def create_new_record(obj)
  end

  # importing the record
  def import_record(id, obj)    
  end

  # update the record
  def update_record(updated_record, obj)
  end

  def set_file(file_obj, type, path)
  end  

  def update_file(file_obj, type, path)
  end  

  def modify_record(record)
  end

  def process_json_file(json_file)
  end

  def parse_data
  end

  def process_file(item_id, field_name, file)
    # get original_filename
    original_filename = file['name']

    puts "Creating Archive and Working Copies for: "
    puts "File Name: #{original_filename}"
    puts "Item Id: #{item_id}"
    puts "Field Name: #{field_name}"

    # file_path is temporarly using backup copy
    # for some files so they are not in the correct 
    # location
    file_path = self.find_file(file['path'], original_filename)

    if file_path != nil && File.exists?(file_path)
      # get Item
      item = Item.find(item_id)

      # copy file for archive and working copies
      self.copy_file(file_path, item.archival_path, original_filename)
      self.copy_file(file_path, item.working_path, original_filename)

      # full path to the file
      archive_file_path = item.archival_path.join(original_filename) 

      hash_values = {
        item_id: item.id,
        form_id: item.form_id, 
        media_type: :archive, 
        filename: original_filename, 
        path: archive_file_path,
        fieldname: field_name
      }

      # creates archive media object in database
      archive_media = Media.new(hash_values)
      archive_media.save          

      # add archive media to item
      item[:data][field_name] << archive_media

      # save updated item
      item.record_timestamps=false
      item.save

      # # update hash values for working copy
      # hash_values[:media_type] = :working
      # hash_values[:path] = item.working_path.join(original_filename) 

      # # creates archive media object in database
      # working_media = Media.new(hash_values)
      # working_media.save     

      # form = Form.where(id: item.form_id).first

      # puts "Starting Conversions for: #{working_media.id} #{original_filename}"
      # Conversion::Actor.new(working_media.id, form.organized_hash[working_media.fieldname]).perform
    end
  end
  
  # method is used to find the file in the backup copy
  # temporarly using the backup copy for testing
  # will be removed later
  def find_file(file_path, original_filename)
    if File.exists?('importing/objects/' + file_path + '/' + original_filename)
      path = 'importing/objects/' + file_path + '/' + original_filename      
    # don't have all the files yet, so using the backup copy
    elsif File.exists?('importing/objects/folklife_1605711112/archive/' + original_filename)
      path = 'importing/objects/folklife_1605711112/archive/' + original_filename
    else
      path = nil
    end
    return path
  end
  
  def copy_file(from_path, to_path, filename)
    # create the path if it doesn't exist 
    FileUtils.mkdir_p(to_path) unless File.directory?(to_path)
  
    # creates the saved file
    file_path = to_path.join(filename) 
  
    # only copy the original archive file
    FileUtils.cp from_path, file_path  
  end 

  def process_files(item_id, files_hash = nil)
    return if files_hash.nil? || files_hash.empty?
    item = Item.find(item_id)
    files_hash.each { |field_name, file_field| 
      # insure any old data is cleared from the
      # original mfcs. We will be recreating in 
      # the new system
      item[:data][field_name] = []
      item.save

      file_field['files']['archive'].each do |file|
        puts "Processing: #{file['name']}"

        self.process_file(item_id, field_name, file)
      end
    }
  end

  def import_file(file)
    @hash = JSON.parse(File.read(file))
  
    # only import objects
    if @hash.present? && Item.where(id: @hash['ID']).count == 0
      # rename timestamps and convert format
      @hash['created_at'] = Time.at(@hash.delete('createTime').to_f) if @hash['createTime']
      @hash['updated_at'] = Time.at(@hash.delete('modifiedTime').to_f) if @hash['modifiedTime'] 
  
      # delete items
      @hash.delete('parentID')
      @hash.delete('defaultProject')
      @hash.delete('objectProject')
  
      # save old file info
      files_hash = { }    
      @hash['data'].each { |key, value| 
        if self.field_has_files?(value)
          files_hash[key] = value
          @hash['data'].delete(key)
        end
      }
      
      array = @hash.keys
      array.each { |key| self.update_key(key) }
  
      # create items
      self.create_item(@hash)
      self.process_files(@hash['id'], files_hash) unless files_hash.empty?
    end  
  end

  private

  def create_item(hash_values)
    begin
      i = Item.new(hash_values)
      i.record_timestamps=false
      i.save(validate: false)
    rescue StandardError => e
      # puts "Rescued: #{e.inspect}"
      # abort
      logger.error e.message
      logger.error e.backtrace.join("\n")      
    end
  end  

  # string contains files key that is not empty
  def field_has_files?(obj)
    begin
      obj.has_key?('files') && !obj['files'].blank?
    rescue
      false
    end
  end  

  def update_key(name)
    @hash[name.to_s.underscore] = @hash.delete(name)
  end  

  def perform
    data_directory = 'importing/objects/data'

    #Dir.glob(File.join(@data_directory, '**', '*.json')).each do |file|
    #Dir.glob(File.join(@data_directory, '38/**', '*.json')).each do |file| 
    #Dir.glob(File.join(@data_directory, '71/**', '*.json')).each do |file|   
    Dir.glob(File.join(data_directory, '114/**', '*.json')).each do |file| 
      next if File.directory?(file) # skip the loop if the file is a directory
    
      @hash = JSON.parse(File.read(file))
      next if @hash == false || Item.where(id: @hash['ID']).present?
    
      puts "Importing: #{file}"

      self.import_file(file)
    end
    
    # force reset for id sequence on table since we are importing.
    ActiveRecord::Base.connection.reset_pk_sequence!('items')    
  end

end

Import.new
