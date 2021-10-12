require 'rails_helper'

RSpec.describe FFMPEG::Video::Metadata, type: :model do
  let(:file) { Rails.root.join('spec','fixtures', 'files', 'test.mov')  }

  context '.init' do
    it 'should set the @file' do
      base = described_class.new(file)
      expect(base.instance_variable_defined?(:@file)).to be true
    end
  end 

  context '.fetch' do
    it 'should be a hash' do 
      base = described_class.new(file)
      expect(base.fetch).to be_a Hash
    end
    
    it 'should have params for width' do 
      base = described_class.new(file)
      expect(base.fetch).to have_key(:width)
      expect(base.fetch).to have_key('width') 
    end 

    it 'should have params for height' do 
      base = described_class.new(file)
      expect(base.fetch).to have_key(:height)
      expect(base.fetch).to have_key('height') 
    end 

    it 'should have params for duration' do 
      base = described_class.new(file)
      expect(base.fetch).to have_key(:duration)
      expect(base.fetch).to have_key('duration') 
    end 

    it 'should have params for bit_rate' do 
      base = described_class.new(file)
      expect(base.fetch).to have_key(:bit_rate)
      expect(base.fetch).to have_key('bit_rate') 
    end 
  end

  context '.ffprobe' do
    it 'expects a string' do 
      base = described_class.new(file)
      expect(base.ffprobe).to be_a String
      expect(base.ffprobe).to include 'ffprobe'
    end 
  end
  
  
end 

