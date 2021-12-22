# Module for the Conversion that determines the type of method that is going to be used.  # Might abstract to an Actor Class.
# @author David J. Davis
# @return [Boolean]
# Setup Conversion 1 For the Test
# ================================================================================
module Conversion
  def self.determine_type(mime)
    if Conversion.audio?(mime)
      'Image'
    elsif Conversion.video?(mime)
      'Video'
    elsif Conversion.image?(mime)
      'Image'
    elsif Conversion.pdf?(mime)
      'Pdf'
    elsif Conversion.text?(mime)
      'Text'
    else
      'Other'
    end
  end

  def self.audio?(mime)
    mime.split('/')[0].casecmp('audio').zero?
  end

  def self.video?(mime)
    'Video' if mime.split('/')[0].casecmp('video').zero?
  end

  def self.image?(mime)
    'Image' if mime.split('/')[0].casecmp('image').zero?
  end

  def self.text?(mime)
    'Text' if mime.split('/')[0].casecmp('text').zero?
  end

  def self.pdf?(mime)
    pdf_types = %w[application text]
    'PDF' if pdf_types.include?(mime.split('/')[0].downcase) && mime.split('/')[1].downcase.include?('pdf')
  end
end
