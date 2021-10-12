class FileInspector::Video
  def self.matches?(mime)
    mime.split('/')[0].casecmp('video').zero? 
  end
end
