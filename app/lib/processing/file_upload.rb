# app/lib/processing/file_upload.rb

# Creates media objects and establishes logic for file submission.
# @author(s) David J. Davis / Tracy A. McCormick
class Processing::FileUpload
  # Takes a temp file and form id and establishes the media objects
  # associated with file submission.  Also saves and moves the files.
  # @param form_id[integer], uploaded_file(ActionDispatch Tempfile)
  # @author(s) David J. Davis / Tracy A. McCormick

  def initialize(item_id, uploaded_file, fieldname)
    @item = Item.find(item_id)
    @uploaded_file = uploaded_file
    @fieldname = fieldname
    @directories = create_directories
    @archive_media = create_archive_media
    @working_media = create_working_media
    save
  end

  def archival_path
    @directories[:archives]
  end

  def working_path
    @directories[:working]
  end

  def archive_media
    @archive_media
  end

  attr_reader :archive_media, :working_media

  def create_archive_media
    # creates media object in database
    Media.new(
      form_id: @item.form_id,
      item_id: @item.id,
      media_type: :archive,
      filename: @uploaded_file.original_filename,
      path: @directories[:archives].join(@uploaded_file.original_filename),
      fieldname: @fieldname
    )
  end

  def create_working_media
    # creates media object in database
    Media.new(
      form_id: @item.form_id,
      item_id: @item.id,
      media_type: :working,
      filename: @uploaded_file.original_filename,
      path: @directories[:working].join(@uploaded_file.original_filename),
      fieldname: @fieldname
    )
  end

  # Checks to make sure the path is created and savable.
  # @author(s) David J. Davis / Tracy A. McCormick
  # @abstract
  def create_directories
    directory_hash = {}
    uuid_path = @item.uuid.tr('-', '/') # converts uuid to a path (unique to each item)
    %w[archives working exports conversions].each do |directory_type|
      path = Rails.root.join(Rails.configuration.mfcs['data_store'], @item.form_id.to_s, uuid_path,
                             directory_type)
      directory_hash[directory_type] = path
      FileUtils.mkdir_p(path) unless File.directory?(path)
    end
    directory_hash.with_indifferent_access
  end

  # Officially saves the files to the filesystem given the path.
  # @author David J. Davis
  # @abstract
  def save_file(path)
    tmp_path = path.join(@uploaded_file.original_filename)
    File.open(tmp_path, 'wb') { |file| file.write(@uploaded_file.read) }
  end

  # Saves working and archival versions using abstract path and save functions.
  # @author David J. Davis
  # @abstract
  def set_versions
    [@directories[:archives], @directories[:working]].each { |path| save_file(path) }
  end

  # Sets and Saves the 2 versions of the file on the system.
  # The save also generates a save of the media object.
  # @author(s) David J. Davis / Tracy A. McCormick
  # @return [String][JSON]
  def save
    set_versions
    @archive_media.save
    @working_media.save
    # queue up the job to convert the file
    ConvertingFileJob.perform_later(@working_media.id)
  end
end
