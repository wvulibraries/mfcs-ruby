# app/lib/file_inspector/image.rb

# File Inspector Image Class
class FileInspector::Image
  def self.matches?(mime)
    mime.split('/')[0].casecmp('image').zero?
  end
end
