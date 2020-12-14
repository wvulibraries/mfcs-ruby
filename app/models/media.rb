# == Schema Information
#
# Table name: media
#
#  id            :bigint           not null,primary key
#  checksum      :string
#  file_errors   :jsonb
#  filename      :string
#  mime_type     :string
#  path          :string
#  size          :string
#  uuid          :string
#  virus_scanned :boolean
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  form_id       :integer
#  item_id       :integer
#
class Media < ApplicationRecord
  # INCLUDES
  # -----------------------------------------------------
  include ActionView::Helpers::NumberHelper

  # Validations
  # ------------------------------------------------------
  # validates :filename, :path, :form_id, :item_id, presence: true
  validates :filename, :path, :form_id, presence: true

  # RAILS CALLBACKS
  # -----------------------------------------------------
  after_initialize :set_defaults, unless: :persisted?

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
  # @author David J. Davis
  # @return [String]
  def mime(path)
    Marcel::MimeType.for Pathname.new(path)
  end

  # Uses other methods to set the information for the db.
  # @author David J. Davis
  # @abstract
  def file_info(path)
    self.checksum = generate_checksum(path)
  end

  # Paths for variety of Media
  # -----------------------------------------------------
  # Archival Path
  # Files should be stored here and then never used again.
  # @author David J. Davis
  # @return [String]
  def archival_path
    Rails.root.join('data', form_id.to_s, uuid_path, 'archives')
  end

  # Working Path
  # A duplicate of the file in the archival path that should be
  # used for conversions and in system use.
  # @author David J. Davis
  # @return [String]
  def working_path
    Rails.root.join('data', form_id.to_s, uuid_path, 'working')
  end

  # Conversion Path
  # The path where conversions will be stored
  # @author David J. Davis
  # @return [String]
  def conversion_path
    Rails.root.join('data', form_id.to_s, uuid_path, 'conversions')
  end

  # Export
  # The path where exports will be stored.
  # @author David J. Davis
  # @return [String]
  def export_path
    Rails.root.join('data', form_id.to_s, uuid_path, 'exports')
  end

  # Splits the UUID into a pah string
  # @author David J. Davis
  # @return [String]
  def uuid_path
    uuid.tr('-', '/')
  end

  # Sets up a hash to return as json
  # @author David J. Davis
  # @return [Hash][JSON]
  def as_json
    {
      media_id: id,
      uuid: uuid,
      filename: filename,
      size: filesize,
      archival_path: archival_path,
      working_path: working_path,
      conversion_path: conversion_path,
      export_path: export_path
    }.to_json
  end

  # Callback Methods
  # -----------------------------------------------------

  # The helper methods to set default values
  # @author David J. Davis
  # @abstract
  def set_defaults
    self.uuid ||= SecureRandom.uuid
  end
end
