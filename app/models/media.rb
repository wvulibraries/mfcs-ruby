# == Schema Information
#
# Table name: media
#
#  id            :bigint           not null, primary key
#  checksum      :string
#  fieldname     :string
#  file_errors   :jsonb
#  filename      :string
#  media_type    :integer
#  mime_type     :string
#  ocr_text      :text
#  path          :string
#  size          :string
#  virus_scanned :boolean
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  form_id       :integer
#  item_id       :integer
#
class Media < ApplicationRecord
  self.table_name = 'media'

  # INCLUDES
  # -----------------------------------------------------
  include ActionView::Helpers::NumberHelper

  # Validations
  # ------------------------------------------------------
  # validates :filename, :path, :form_id, :item_id, presence: true
  validates :filename, :path, :form_id, presence: true

  # Associations
  # -----------------------------------------------------
  belongs_to :item
  belongs_to :form

  # Enums
  # ----------------------------------------------------
  # enum media_type: { image: 0, audio: 1, video: 2, pdf: 3 }
  enum media_type: { archive: 0, working: 1, conversion: 2, export: 3, thumbnail: 4 }

  # Callbacks
  # -----------------------------------------------------
  before_save :file_info, unless: :persisted?

  # Methods for File Handling
  # -----------------------------------------------------

  # Gets the file size of the file
  # Makes it Human Readable.
  # @author David J. Davis
  # @return [String]
  def filesize(path)
    number_to_human_size(File.size(path))
  end

  # Create a checksum using a filepath.
  # @param filepath: The path of the file on the server
  # @author David J. Davis
  # @return [String]
  def generate_checksum(filepath)
    return false unless File.exist?(filepath)

    Digest::MD5.hexdigest(File.read(filepath))
  end

  # Uses Basecamps Marcel Gem to check the mimetype
  # @author(s) David J. Davis / Tracy A. McCormick
  # @return [String]
  def mime(path)
    detected_type = Marcel::MimeType.for Pathname.new(path)

    # if the detected_type is 'video/x-ms-asf' return
    # the type for the extension only instead of the detected
    # type.
    if detected_type == 'video/x-ms-asf'
      Marcel::MimeType.for extension: path.last(4).to_s
    else
      detected_type
    end
  end

  # Uses other methods to set the information for the db.
  # @author David J. Davis
  # @abstract
  def file_info
    self.checksum = generate_checksum(path)
    self.mime_type = mime(path)
    self.size = filesize(path)
  end

  # Builds a Common Use Data Hash
  # @author David J. Davis
  # @return [Hash]
  def info
    {
      checksum: generate_checksum(path),
      fieldname: fieldname,
      mime: mime(path),
      filename: filename,
      filesize: filesize(path),
      base_type: mime(path).split('/').first
    }
  end

  # Sets up a hash to return as json
  # @author David J. Davis
  # @return [Hash][JSON]
  def json
    info.to_json
  end
end
