require 'rails_helper'

RSpec.describe Ffmpeg::Audio, type: :model do
  let(:file) { Rails.root.join('spec','fixtures', 'files', 'storm.wav')  }
  let(:to_file) { Rails.root.join('tests', 'data', 'files', 'storm.mp3') }
  let(:test_file_dir) { Rails.root.join('tests', 'data', 'files') }

  context '.normalize' do
    it 'returns a string' do
      base = described_class.new(file, to_file)
      expect(base.normalize).to be_a Array
    end

    it 'should include keywords from normal' do 
      base = described_class.new(file, to_file)
      base.normalize
      expect(base.instance_variable_get(:@command)).to include '-filter:a loudnorm'
    end 
  end

  context '.bitrate' do 
    it 'should be a string' do
      base = described_class.new(file, to_file)
      expect(base.bitrate('22k')).to be_a Array
    end
    
    it 'should be a string' do
      base = described_class.new(file, to_file)
      expect(base.bitrate('22k')).to include '-ab 22k'
    end
  end 

  context '.command' do 
    it 'should return a string without the block' do
      base = described_class.new(file, to_file)
      expect(base.command).to be_a String
    end

    it 'should return a string with the block' do
      base = described_class.new(file, to_file)
      expect(base.command{ bitrate '22k' }).to be_a String
    end

    # not sure if we should be testing exact commands or includes here... 
    it 'should return a that matches the following exact command' do 
      base = described_class.new(file, to_file)
      expect(base.command).to eq "/usr/bin/ffmpeg -hide_banner -loglevel error -y -i #{file} -filter:a loudnorm #{to_file}"
    end 

    it 'should return a string that contains the specifics for the bitrate' do 
      base = described_class.new(file, to_file)
      expect(base.command{ bitrate '22k' }).to eq "/usr/bin/ffmpeg -hide_banner -loglevel error -y -i #{file} -filter:a loudnorm -ab 22k #{to_file}"
    end 

    it 'should throw a method missing exception' do
      base = described_class.new(file, to_file)
      expect{ base.command{ increase_volume '22k' } }.to raise_error(NoMethodError)
    end

    it 'should inject a custom option' do 
      base = described_class.new(file, to_file, { vf: "select='between(t,1,5)'" })
      expect(base.command).to include "-vf select='between(t,1,5)'"
    end 
  end   


  context '.perform' do 
    before(:each) do
      FileUtils.mkdir_p(test_file_dir) unless File.exists?(test_file_dir)
    end 

    it 'expects the perform to be false because command has not been called.' do 
      base = described_class.new(file, to_file)
      expect(base.perform).to be false
    end 

    it 'expects the perform to return true as the command should pass' do 
      base = described_class.new(file, to_file)
      base.command{ bitrate '22k' }
      expect(base.perform).to be true
    end 
  end 
end 

