require 'rails_helper'

RSpec.describe Conversion::Actor do 

  let(:form) { FactoryBot.build_stubbed(:file_conversion_form) }

  let(:image_media) { FactoryBot.create(:media) }
  let(:audio_media) { FactoryBot.create(:audio) }

  context 'types' do
    it 'should have some types' do 
      expect(Conversion::Actor::TYPES).to be_truthy 
    end 

    it 'should have 4 options' do  
       expect(Conversion::Actor::TYPES.count).to eq 4 
    end  
  end

  context '.init' do
    it 'it sets the instance variable of media' do
      params_hash = form.organized_hash[:files]
      base = described_class.new(audio_media.id, params_hash)
      expect(base.instance_variable_defined?(:@media)).to be true
    end
  end

  context '.conversion' do
    it 'expects the item to be a type of class or constant' do 
      params_hash = form.organized_hash[:files]
      base = described_class.new(audio_media.id, params_hash)
      expect(base.conversion.class).to be_a Class
    end 

    it 'expects that the @conversion is a audio file' do 
      params_hash = form.organized_hash[:files]
      base = described_class.new(audio_media.id, params_hash)
      expect(base.conversion).to eq Conversion::Audio
    end 

    it 'expects that the @conversion is an image file' do 
      params_hash = form.organized_hash[:files]
      base = described_class.new(image_media.id, params_hash)
      expect(base.conversion).to eq Conversion::Image
    end 
  end
  
  context '.perform' do
    it 'should be truthy' do 
      params_hash = form.organized_hash[:files]
      base = described_class.new(image_media.id, params_hash)
      allow(base).to receive('perform').and_return(true)
      expect(base.perform).to be true
    end 
  end
  
  
end