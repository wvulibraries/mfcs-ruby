# Creates media objects and establishes logic for file submission.
# @author David J. Davis
class Processing::FileUpload
  # Takes a temp file and form id and establishes the media objects
  # associated with file submission.  Also saves and moves the files.
  # @param form_id[integer], uploaded_file(ActionDispatch Tempfile)
  # @author David J. Davis
  def initialize(item, uploaded_file)
    @item = item
    @uploaded_file = uploaded_file
    @directories = create_directories
  end

  # Checks to make sure the path is created and savable.
  # @author David J. Davis
  # @abstract
  def create_directories 
    directory_hash = {}
    ['archives', 'working', 'exports', 'conversions'].each do |directory_type| 
      uuid_path = @uuid.tr('-', '/') #converts uuid to a path (unique to each item)
      path = Rails.root.join('data', form_id.to_s, uuid_path, directory_type)
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
  # @author David J. Davis
  # @return [String][JSON]
  def save
    set_versions
    media.path = media.working_path
    media.save
  end
end
