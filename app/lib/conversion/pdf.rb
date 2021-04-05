class Conversion::Pdf
  def self.matches?(mime)
    %w[application text].include?(mime.split('/')[0].downcase) && mime.split('/')[1].downcase.include?('pdf')
  end

  def initialize
    
  end
end