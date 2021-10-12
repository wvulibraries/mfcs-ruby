class FileInspector::Image
  def self.matches?(mime)
    mime.split('/')[0].casecmp('image').zero?
  end
end
