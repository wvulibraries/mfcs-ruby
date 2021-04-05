require 'rails_helper'

RSpec.describe Conversion::Type::Image do 
  data = JSON.parse(File.read(Rails.root.join("spec/fixtures/files/mimes_hash.json")))

  context '.matches?' do
    data['image'].sample(10).each do |mime| 
      it "#{mime} should pass the matcher." do
        expect(described_class.matches?(mime)).to be true
      end 
    end 

    data['audio'].sample(10).each do |mime| 
      it "#{mime} fails the matcher wrong file type" do
        expect(described_class.matches?(mime)).to be false
      end 
    end 
  end

  context '.perform' do
    it 'should be a class' do 
      expect(described_class.perform.class).to be Class
    end 

    it 'should return a Conversion::Image class' do 
      expect(described_class.perform).to eq Conversion::Image
    end 
  end
end 