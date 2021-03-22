require 'rails_helper'

RSpec.describe FFMPEG::Video, type: :model do
  let(:file) { Rails.root.join('spec','fixtures', 'files', 'test.mov')  }
  let(:to_file) { Rails.root.join('tests', 'data', 'files', 'storm.mp4') }

  context 'size' do
    it 'expects the width and height to be positive numbers' do 
      base = described_class.new(file, to_file)
      command = base.command do
         size 300, 500 
      end 
      expect(base).to be_truthy
    end 

    it 'expects an error to raise because ratio incorrect' do
      base = described_class.new(file, to_file)
      expect { base.command { size 300, 500, 'test'} }.to raise_error(ArgumentError)
    end

    it 'expects an error to raise because ratio incorrect' do
      base = described_class.new(file, to_file)
      expect { base.command { size nil, nil } }.to raise_error(ArgumentError)
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
      expect(command).to include "scale=w=720:h=1024:force_original_aspect_ratio=decrease"
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
        size '720', '1024'
      end 
      expect(base.perform).to be true
    end 
  end 
end 

