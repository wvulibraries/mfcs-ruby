# Creates media objects and establishes logic for file submission.
# @author David J. Davis
class Processing::FileUpload
  # Takes a temp file and form id and establishes the media objects
  # associated with file submission.  Also saves and moves the files.
  # @param form_id[integer], uploaded_file(ActionDispatch Tempfile)
  # @author David J. Davis
  def initialize(form_id, uploaded_file)
    @form_id = form_id
    @uploaded_file = uploaded_file
    # call media, so media can be used as a getter/setter
    media
  end

  # creates a media object to use in the file upload
  def media
    @media ||= Media.new({
                           filename: @uploaded_file.original_filename,
                           form_id: @form_id,
                           size: @uploaded_file.size,
                           mime_type: @uploaded_file.content_type
                         })
  end

  # Checks to make sure the path is created and savable.
  # @author David J. Davis
  # @abstract
  def create_path(path)
    FileUtils.mkdir_p(path) unless File.directory?(path)
    true
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
    [@media.archival_path, @media.working_path].each do |path|
      create_path(path)
      save_file(path)
    end
  end

  # Sets and Saves the 2 versions of the file on the system.
  # The save also generates a save of the media object.
  # @author David J. Davis
  # @return [String][JSON]
  def save
    set_versions
    media.file_info(media.working_path.join(@uploaded_file.original_filename))
    media.path = media.working_path
    media.save
    media.json
  end
end
