class Conversion::Ocr 
  def initialize(media_id)
    @media = Media.find(media_id) 
  end  

  def ocr(filepath, language = 'eng')
    ocr_file = RTesseract.new filepath.to_s 
    ocr_file.to_s 
  end 

  def perform
    @media['ocr_text'] = ocr(@media.path)
    @media.save
  end 

  def save_text 
  end
  
  def save_pdf 
  end 
end 