require 'rails_helper'

RSpec.describe Conversion::Operation::AspectRatio, type: :model do
  let(:file) {Rails.root.join('spec','fixtures', 'files', 'test_image_1.jpg')}
  let(:form) { FactoryBot.build_stubbed(:file_conversion_form) }
  
  context 'self.perform' do
    before(:each) do 
      @params = form.organized_hash[:files]
    end 

    it 'aspect ratio should return an array [w, h]' do
      expect(described_class.perform(file, @params)).to be_a Array
    end 

    it 'expects the defaults are fine' do 
      expected_result = [@params.fetch('image_width').to_i, @params.fetch('image_height').to_i] 
      expect(described_class.perform(file, @params)).to eq expected_result
    end 

    it 'expects ratio to set the width' do
      @params['image_width'] = nil # original aspect ratio is 3:2 
      # supplied height is 600 which is 3x the original so we can assume 
      # 900 x 600
      expect(described_class.perform(file, @params)).to eq [900, 600] 
    end 

    it 'expects ratio set the height' do
      @params['image_height'] = nil # original aspect ratio is 3:2 
      @params['image_width'] = 900 # supply 900 and the end value will be 900x600
      expect(described_class.perform(file, @params)).to eq [900, 600] 
    end 

    it 'assumes that both are empty' do
      @params['image_height'] = nil
      @params['image_width'] = nil
      expect(described_class.perform(file, @params)).to eq [600, 400] 
    end 
  end 

  context 'self.find_width' do
    it 'should provide the width given the new size is smaller' do
      expect(described_class.find_width(200, 900, 600)).to eq 300 
    end 

    it 'should provide the width given the new size is bigger' do
      expect(described_class.find_width(2000, 900, 600)).to eq 3000
    end 
  end 

  context 'self.find_height' do
    it 'should provide the proper height given the new size is smaller' do
      expect(described_class.find_height(300, 900, 600)).to eq 200 
    end 

    it 'should provide the proper height given the new size is bigger' do
      expect(described_class.find_height(3000, 900, 600)).to eq 2000
    end 
  end 
end 