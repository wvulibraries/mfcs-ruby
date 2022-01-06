# app/lib/file_inspector/video.rb

# File Inspector Video Class
class FileInspector::Video
  def self.matches?(mime)
    mime.split('/')[0].casecmp('video').zero?
  end
end
