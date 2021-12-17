class ProcessingJob < ApplicationJob
  queue_as :default

  # Need to create working files for all files in the archive
  # Figure out what conversions need to be done
  # Run the conversions possibly in a specific order.

  Conversion::Image
  Conversion::Audio
  Conversion::Video
  Conversion::Pdf

  def perform(item_id)
    # gets the media and item
    # media = Media.find(media_id)
    # item = Item.find(media.item_id)

    # ConvertingFileJob.perform_later(media_id)
  end

  # SHOULD BE
  # Conversion::Image
  # Conversion::ImageThumbnail
  # Conversion::Watermark
  # Conversion::Audio
  # Conversion::Video
  # Conversion::VideoThumbnail
  # Conversion::CombinePDF

  # ? Conversion::PdfImage
  # ? Conversion::PdfThumbnail

  # Note - Testing OCR TIF doesn't seem work work as well as jpg files.
  # Conversion::OCR # ---> WHERE DOES THE OCR STUFF GET SAVED? MEDIA?

  # Use Case
  # =======================================================================

  # Files Field
  # CAN HAVE JPGS, AUDIO, VIDEO, ETC.
  # Conversions setup for each of them.

  # Single Tiff
  # Image Conversion
  # Watermark
  # Thumbnail
  # OCR

  # Multiple Tiffs
  # Image Conversion
  # Watermark
  # Thumbnail
  # OCR
  # Combine PDF

  # Multiple Tiffs, a Video, and an Audio File
  # Image Conversion
  # Watermark
  # Thumbnail
  # OCR
  # Combine PDF
  # Audio Conversion
  # Video Conversion
  # Video Thumbnail

  # PDF Conversion
  # =======================================================================
  # Combine all images that have already been converted
  # Run Tessereract OCR on the combine PDF or before the combination has taken place.

  # Image Conversion
  # =======================================================================
  # Converted Image (Border, Size, Format)
  # After the Conversion
  # Thumbnails, Watermarking, Tesseract, Combining to PDF

  # Video Conversion
  # =======================================================================
  # Alterting Video (Size, Bitrate, Etc)
  # Thumbnails

  # Audio Conversion
  # =======================================================================
  # Alter Audio (Bitrate, Format)
end
