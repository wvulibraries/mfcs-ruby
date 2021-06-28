class FileInspector::Text
  def self.matches?(mime)
    mime.split('/')[0].casecmp('text').zero? && mime.split('/')[1].downcase.exclude?('pdf')
  end
end