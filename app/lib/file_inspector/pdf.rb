# app/lib/file_inspector/pdf.rb

# File Inspector Pdf Class
class FileInspector::Pdf
  def self.matches?(mime)
    %w[application
       text].include?(mime.split('/')[0].downcase) && mime.split('/')[1].downcase.include?('pdf')
  end
end
