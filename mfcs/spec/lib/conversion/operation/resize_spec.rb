require 'rails_helper'

RSpec.describe Conversion::Operation::Resize, type: :model do
  let(:form) { FactoryBot.build_stubbed(:file_conversion_form) }
  let(:stubbed_media) { FactoryBot.build_stubbed(:media) }
  let(:media) { FactoryBot.create(:media) }

  context '.init' do 
    it 'initalizes' do
      params_hash = form.organized_hash[:files]
      base = described_class.new(params_hash)
      expect(base).to be_a described_class
    end

    it "assigned @width" do
      params_hash = form.organized_hash[:files]
      base = described_class.new(params_hash)
      expect(base.instance_variable_defined?(:@width)).to be true
    end

    it "assigned @height" do
      params_hash = form.organized_hash[:files]
      base = described_class.new(params_hash)
      expect(base.instance_variable_defined?(:@height)).to be true
    end
  end 

  context 'defaults' do
    it 'expects @width to be nil' do
      params_hash = form.organized_hash[:files]
      params_hash['image_width'] = nil
      base = described_class.new(params_hash)
      expect(base.instance_variable_get('@width')).to be_nil
    end 

    it 'expects passed value @width' do
      params_hash = form.organized_hash[:files]
      params_hash['image_width'] = '300'
      base = described_class.new(params_hash)
      expect(base.instance_variable_get('@width')).to eq '300'
    end 

    it 'expects default @height' do
      params_hash = form.organized_hash[:files]
      params_hash['image_height'] = nil
      base = described_class.new(params_hash)
      expect(base.instance_variable_get('@height')).to be_nil
    end 

    it 'expects passed value @height' do
      params_hash = form.organized_hash[:files]
      params_hash['image_height'] = '500'
      base = described_class.new(params_hash)
      expect(base.instance_variable_get('@height')).to eq '500'
    end 
  end 

  context 'self.matches?' do
    it 'matches' do 
      params_hash = form.organized_hash[:files]
      params_hash['image_height'] = '300'
      params_hash['image_width'] = '500'
      expect(described_class.matches?(params_hash)).to be true
    end 

    it 'matches because one value is true aspect ratio class will fix that' do 
      params_hash = form.organized_hash[:files]
      params_hash['image_height'] = nil
      params_hash['image_width'] = '500'
      expect(described_class.matches?(params_hash)).to be true
    end 

    it 'matches because one value is true aspect ratio class will fix that' do 
      params_hash = form.organized_hash[:files]
      params_hash['image_height'] = '500'
      params_hash['image_width'] = nil
      expect(described_class.matches?(params_hash)).to be true
    end 

    it 'does not match' do 
      params_hash = form.organized_hash[:files]
      params_hash['image_height'] = nil
      params_hash['image_width'] = nil
      expect(described_class.matches?(params_hash)).to be false
    end 
  end
  
  context '.call' do
    it 'stubs the call method to work somewhat properly' do 
      params_hash = form.organized_hash[:files]
      # set up a dummy conversion object
      convert_object = double() 
      allow(convert_object).to receive(:resize).and_return(true)
      # run the test to make sure it comes back truthyish
      base = described_class.new(params_hash)
      expect(base.call(convert_object)).to be_truthy
    end 
  end 
end 