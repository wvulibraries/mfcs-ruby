# app/lib/file_inspector/type.rb

# Looks into File Type Form Established Mime
class FileInspector::Type
  TYPES = [
    FileInspector::Image,
    FileInspector::Audio,
    FileInspector::Video,
    FileInspector::Text,
    FileInspector::Pdf
  ].freeze

  # Sets up mime type instance
  # @author David J. Davis
  def initialize(mime)
    @mime = mime
  end

  # Sets up the conversions that will be called.  If the matcher is accepted.
  # @return Class [Object]
  # @author David J. Davis
  def file_type
    @file_type = TYPES.find { |type| type.matches?(@mime) }.name.demodulize
  end
end
