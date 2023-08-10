require 'rails_helper'

RSpec.describe FileInspector::Type, type: :model do
  data = JSON.parse(File.read(Rails.root.join("spec/fixtures/files/mimes_hash.json")))

  context '.initialize' do
    it 'sets mime' do 
      base = described_class.new('image/jpg')
      expect(base.instance_variable_defined?(:@mime)).to be true
    end  
  end
  
  context '.file_type' do
    data['image'].sample(3).each do |mime| 
      it "#{mime} should pass the matcher." do
        base = described_class.new(mime)
        expect(base.file_type).to eq 'Image'
      end 
    end 

    data['video'].sample(3).each do |mime| 
      it "#{mime} should pass the matcher." do
        base = described_class.new(mime)
        expect(base.file_type).to eq 'Video'
      end 
    end 

    data['audio'].sample(3).each do |mime| 
      it "#{mime} should pass the matcher." do
        base = described_class.new(mime)
        expect(base.file_type).to eq 'Audio'
      end 
    end 

    data['text'].sample(3).each do |mime| 
      it "#{mime} should pass the matcher." do
        base = described_class.new(mime)
        expect(base.file_type).to eq 'Text'
      end 
    end 

    data['pdf'].sample(3).each do |mime| 
      it "#{mime} should pass the matcher." do
        base = described_class.new(mime)
        expect(base.file_type).to eq 'Pdf'
      end 
    end 
  end 
  
end 