# Video Factory
class Conversion::Video < Conversion::Base  

  def self.matches?(mime) 
    mime.split('/')[0].casecmp('video').zero?
  end 

  def initialize 
  end 
end 