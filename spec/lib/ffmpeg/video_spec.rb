require 'rails_helper'

RSpec.describe FFMPEG::Video, type: :model do
  let(:file) { Rails.root.join('spec','fixtures', 'files', 'test.mov')  }
  let(:to_file) { Rails.root.join('tests', 'data', 'files', 'storm.mp4') }

  context 'size' do
    it 'expects size to be the original size' do 
      base = described_class.new(file, to_file)
      size = base.size 1280,1280
      expect(size).to be_a Array
      expect(size.join(' ')).to include '-s 1280x720'
    end 
  end

  context '.bitrate' do
    it 'expects the bit rate to return an array' do 
      base = described_class.new(file, to_file)
      expect(base.bitrate '18000').to be_a Array
    end 

    it 'expect it to have the inluded value' do 
      base = described_class.new(file, to_file)
      expect(base.bitrate '18000').to include '-vb 18000'
    end 

    it 'nothing passed should default 24000' do 
      base = described_class.new(file, to_file)
      expect(base.bitrate).to include '-vb 24000'
    end 
  end

  context 'command' do
    it 'expect command with bitrate and size' do 
      base = described_class.new(file, to_file)
      command = base.command do 
        bitrate '18000'
        size '720', '1024'
      end 

      expect(command).to be_a String
      expect(command).to include "-vb 18000" 
      expect(command).to include "-s 720x405"
    end 
  end

  context '.metadata' do
    it 'should have height and width keys' do 
      base = described_class.new(file, to_file)
      res = base.metadata
      expect(res).to have_key(:width)
      expect(res).to have_key(:height)
    end 
  end
  
  context '.perform' do 
    it 'expects the perform to be false because command has not been called.' do 
      base = described_class.new(file, to_file)
      expect(base.perform).to be false
    end 

    it 'expects the perform to return true as the command should pass' do 
      base = described_class.new(file, to_file)
      command = base.command do 
        bitrate '18000'
        size '1280', '720'
      end 
      puts command.inspect
      expect(base.perform).to be true
    end 
  end 
end 

