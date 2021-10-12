require 'rails_helper'

RSpec.describe AspectRatio, type: :model do
  let(:o_width){ 1024 }
  let(:o_height) { 768 } 

  context '.init' do
    it 'should set original height' do
      base = described_class.new(o_width, o_height, 800, 400)
      expect(base.instance_variable_defined?(:@original_height)).to be true
    end

    it 'should set original width' do
      base = described_class.new(o_width, o_height, 800, 400)
      expect(base.instance_variable_defined?(:@original_width)).to be true
    end

    it 'should set new width' do
      base = described_class.new(o_width, o_height, 800, 400)
      expect(base.instance_variable_defined?(:@width)).to be true
    end

    it 'should set new height' do
      base = described_class.new(o_width, o_height, 800, 400)
      expect(base.instance_variable_defined?(:@height)).to be true
    end
  end

  context '.calculate' do
    it 'new values are nil return originals' do 
      base = described_class.new(o_width, o_height, nil, nil)
      expect(base.calculate).to eq [1024, 768]
    end 

    it 'height is nil and width is positive' do 
      base = described_class.new(o_width, o_height, 400, nil)
      expect(base.calculate).to eq [400,300]
    end 

    it 'width and height are given, but not correct to aspect ratio ignore height use width' do 
      base = described_class.new(o_width, o_height, 800, 800)
      expect(base.calculate).to eq [800,600]
    end 

    it 'width is nil find the width' do
      base = described_class.new(o_width, o_height, nil, 800)
      expect(base.calculate).to eq [1066,800]
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