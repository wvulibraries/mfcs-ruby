class FileInspector::Audio
  def self.matches?(mime)
    mime.split('/')[0].casecmp('audio').zero?
  end
end
