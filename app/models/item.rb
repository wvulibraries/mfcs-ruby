# == Schema Information
#
# Table name: items
#
#  id             :bigint           not null, primary key
#  created_by     :integer
#  data           :jsonb
#  idno           :string
#  metadata       :boolean
#  modified_by    :integer
#  public_release :boolean
#  soft_delete    :boolean
#  uuid           :string
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  form_id        :integer
#

require 'zip'

class Item < ApplicationRecord
  # Context
  # -----------------------------------------------------
  include Readonly

  # Associations
  # -----------------------------------------------------
  belongs_to :form
  #has_many :media, dependent: :restrict_with_exception
  has_many :media, dependent: :destroy

  # Audits
  # -----------------------------------------------------
  audited max_audits: 50

  # Validations
  # -----------------------------------------------------
  validate :custom_data_entry

  # Callbacks
  # -----------------------------------------------------
  after_initialize :set_defaults, unless: :persisted?
  before_save :idno_setups, unless: proc { idno_set? }

  before_destroy :destroy_media 
  after_destroy :remove_empty_folders, :remove_path

  # before_soft_delete :soft_delete_media   
  # after_soft_delete :remove_empty_folders

  # temporary
  # after_save :processing

  # References the custom validation actor. Calling the actor on each field
  # except for file fields gives us a validation on this model.
  # @author David J. Davis
  # @return [truthy] possible return of IDNO
  def idno_setups
    # skips the hole process if a metadata form
    return if form.nil? || form.metadata?

    idno_settings = form.idno_field
    if idno_settings['managed_by'].to_s.casecmp('system').zero?
      idno_number = Idno::SystemIdno.new(form.id, idno_settings).formatted_idno
      self.idno = idno_number
      data['idno'] = idno_number
    elsif idno_settings['managed_by'].to_s.casecmp('user').zero?
      self.idno = data['idno']
    end
  end

  # Boolean for Proc Method used on after_save callback
  # This should keep the idno evaluations from happening more than once.
  # @author David J. Davis
  # @return [Boolean]
  def idno_set?
    return true if persisted?

    idno.present? && form.object_form?
  end

  # References the custom validation actor. Calling the actor on each field
  # except for file fields gives us a validation on this model.
  # @author David J. Davis / Tracy McCormick
  # @abstract not really a return value, it is checked by the valid? model.
  def custom_data_entry
    return true if data.blank?

    if persisted?
      return true unless changes[:data]

      validate_data(changed_data)
    else
      validate_data(data)
    end
  end

  # Paths for variety of Media
  # -----------------------------------------------------
  # Archival Path
  # Files should be stored here and then never used again.
  # @author David J. Davis
  # @return [String]
  def archival_path
    Rails.root.join(Rails.configuration.mfcs['data_store'], form_id.to_s, uuid_path, 'archives')
  end
  alias archive_path archival_path

  # Working Path
  # A duplicate of the file in the archival path that should be
  # used for conversions and in system use.
  # @author David J. Davis
  # @return [String]
  def working_path
    Rails.root.join(Rails.configuration.mfcs['data_store'], form_id.to_s, uuid_path, 'working')
  end

  # Conversion Path
  # The path where conversions will be stored
  # @author David J. Davis
  # @return [String]
  def conversion_path
    Rails.root.join(Rails.configuration.mfcs['data_store'], form_id.to_s, uuid_path, 'conversions')
  end

  # Thumb Path
  # The path where conversions will be stored
  # @author David J. Davis
  # @return [String]
  def thumbnail_path
    Rails.root.join(Rails.configuration.mfcs['data_store'], form_id.to_s, uuid_path, 'conversions',
                    'thumb')
  end
  alias thumb_path thumbnail_path

  # Export
  # The path where exports will be stored.
  # @author David J. Davis
  # @return [String]
  def export_path
    Rails.root.join(Rails.configuration.mfcs['data_store'], form_id.to_s, uuid_path, 'exports')
  end

  def storage_path
    Rails.root.join(Rails.configuration.mfcs['data_store'], form_id.to_s, uuid_path)
  end

  # Splits the UUID into a path string
  # @author David J. Davis
  # @return [String]
  def uuid_path
    uuid.tr('-', '/')
  end

  # Callback Methods
  # -----------------------------------------------------

  def processing
    ProcessingJob.perform_later(id)
  end

  # The helper methods to set default values
  # @author David J. Davis
  # @abstract
  def set_defaults
    self.uuid ||= SecureRandom.uuid
  end

  # returns the id of the first thumbnail media image
  # or -1 if no thumbnail is found.
  # @author Tracy A. McCormick
  # @return integer
  def thumb_id
    media = Media.where(item_id: id, media_type: 'thumbnail').first
    media.nil? ? self.data['type'] : 0
  end

  # returns the id of the first media object found
  # or -1 if no conversion object is found.
  # @author Tracy A. McCormick
  # @return integer
  def image_id
    media = Media.where(item_id: id, media_type: 'conversion').first
    media.nil? ? -1 : media.id
  end

  def identifier
    if self['data']['identifier'].to_s != ''
      self['data']['identifier'].to_s
    else
      self['data']['idno'].to_s
    end
  end

  # returns the count of files in the passed field
  # @author Tracy A. McCormick
  # @return integer
  def file_field_count(field)
    self['data'][field].nil? ? 0 : self['data'][field].count
  end

  def download_all
    # set zip filename
    zip_file_name = "#{id}_#{Time.now.strftime('%Y%m%d%H%M%S')}.zip"

    # create export directory
    FileUtils.mkdir_p(export_path) unless File.exist?(export_path)

    Zip::File.open(export_path.join(zip_file_name), Zip::File::CREATE) do | zipfile |
      Dir["#{working_path}/**/**"].map{|e|e.sub %r[^#{working_path}/],''}.reject{|f|f==zip_file_name}.each do | item |
        zipfile.add(item, File.join(working_path, item))
      end
      if File.exist?(conversion_path)
        Dir["#{conversion_path}/**/**"].map{|e|e.sub %r[^#{conversion_path}/],''}.reject{|f|f==zip_file_name}.each do | item |
          zipfile.add(item, File.join(conversion_path, item))
        end  
      end
      if File.exists?(thumbnail_path) 
        Dir["#{thumbnail_path}/**/**"].map{|e|e.sub %r[^#{thumbnail_path}/],''}.reject{|f|f==zip_file_name}.each do | item |
          zipfile.add(item, File.join(thumbnail_path, item))
        end   
      end      
    end

    # return the location of the zip file
    return export_path.join(zip_file_name)
  end

  def project_ids
    Form.find(form_id).project_ids
  end
  
  protected

  def timestamp_attributes_for_create
    [:updated_at]
  end

  private

  # This method loops through the data to use the Validator Actor
  # If there is not valid then add to the errors field.
  # @author David J. Davis / Tracy A. McCormick
  # @abstract Sets errors to the item model
  def validate_data(validation_data)
    validation_data.each do |field, input|
      next if form.file_fields.include? field

      valid = Validator::Actor.new(form.id, field, input).perform
      unless valid[:status] == true || valid[:status].nil?
        errors.add(field, valid[:errors].join(' '))
      end
    end
  end

  # This method loops through the data to see if the data has changed
  # from the persisted methods.
  # @author David J. Davis
  # @return [Hash]
  def changed_data
    new_validations = {}
    changes[:data][0].each do |key, value|
      new_validations[key] = changes[:data][1][key] if changes[:data][1][key] != value
    end
    new_validations
  end

  
  # destroy media objects requires media_type
  # conversions, thumbnail, working, archive 
  # are valid media_types
  # @author Tracy A. McCormick
  def destroy_media_objects(media_type)
    # find all converted media objects for this item
    medias = Media.where(item_id: id, media_type: media_type)
    # destroy each media objects
    medias.each do |media|
      media.destroy
    end    
  end

  # Destroy all media objects for this item
  # of generated files
  # @author Tracy A. McCormick  
  def destroy_media
    media_types = ['thumbnail', 'conversion', 'working', 'archive']
    media_types.each { |media_type|
      destroy_media_objects(media_type)    
    }
  end    
  
  # Destroy all thumbnail and converted media objects
  # used mostly for reprocessing to delete old versions
  # of generated files
  # @author Tracy A. McCormick  
  def destroy_generated_media
    media_types = ['thumbnail', 'conversion']
    media_types.each { |media_type|
      destroy_media_objects(media_type)    
    }
  end

  # Soft Delete all media objects for this item
  # @author Tracy A. McCormick  
  def soft_delete_media
    # destroy all generated media files
    destroy_generated_media
    # soft delete all media objects
    medias.each do |media|
      media.soft_delete == true
      media.save
    end 
  end    

  # remove empty folders for thumbnails, conversions, working and archive files
  # @author Tracy A. McCormick    
  def remove_empty_folders
    # insure all folders are removed
    FileUtils.rm_rf(thumbnail_path) if File.directory?(thumbnail_path) && Dir.empty?(thumbnail_path)     
    FileUtils.rm_rf(conversion_path) if File.directory?(conversion_path) && Dir.empty?(conversion_path)     
    FileUtils.rm_rf(working_path) if File.directory?(working_path) && Dir.empty?(working_path)     
    FileUtils.rm_rf(archive_path) if File.directory?(archive_path) && Dir.empty?(archive_path) 
  end

  # remove long path for file storage derived from the uuid
  # performs reverse recursion on the file path subfolders.
  # @author Tracy A. McCormick  
  def remove_path
    # path to be removed
    directory = Rails.root.join(Rails.configuration.mfcs['data_store'], form_id.to_s, uuid_path)

    # return if the directory does not exist
    return unless File.directory?(directory)

    # loop to remove empty folders in path stop if not empty
    loop do
      FileUtils.rm_rf(directory) if File.directory?(directory) && Dir.empty?(directory) 
      directory = Pathname.new(directory).parent.to_s
      break if !Dir.empty?(directory)
    end
  end  
  
end
