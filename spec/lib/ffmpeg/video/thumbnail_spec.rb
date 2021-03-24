require 'rails_helper'

RSpec.describe FFMPEG::Video::Thumbnail, type: :model do
  let(:file) { Rails.root.join('spec','fixtures', 'files', 'test.mov')  }
  let(:to_file) { Rails.root.join('tests', 'data', 'files', 'test.jpg') }


  context '.frames' do
    it 'should set the param number to 1 as default' do 
      base = described_class.new(file, to_file)
      frames_command = base.frames 
      expect(frames_command).to be_a Array
      expect(frames_command.join(' ')).to include '-vframes 1'
    end    

    it 'should set the param number to 1 as default' do 
      base = described_class.new(file, to_file)
      frames_command = base.frames 10
      expect(frames_command).to be_a Array
      expect(frames_command.join(' ')).to include '-vframes 10'
    end    
  end

  context '.disable_audio!' do
    it 'should disable the audio and add that command so it eats less processing power' do 
      base = described_class.new(file, to_file)
      command = base.disable_audio!
      expect(command).to be_a Array
      expect(command.join(' ')).to include '-an'
    end 
  end

  context '.size' do
    it 'should add the size to the command' do 
      base = described_class.new(file, to_file)
      command = base.size 400, 400
      expect(command).to be_a Array
      expect(command.join(' ')).to include '-s 400x225'
    end 
  end

  context '.command' do
    it 'should join the command as a string' do
      base = described_class.new(file, to_file)
      command = base.command do 
        size 200,400
        disable_audio! 
        frames 1 
      end 
      expect(command).to be_a String
      expect(command).to include '-an'
      expect(command).to include '-s 200x112'
      expect(command).to include '-vframes 1'
    end  
  end

  context '.frame_grab' do
    it 'should add the frame to grab.' do 
      base = described_class.new(file, to_file)
      command = base.frame_grab
      expect(command).to be_a Array
      expect(command.join(' ')).to include '-ss 00:00:05'
    end 

    it 'should add the frame to grab with custom time' do 
      base = described_class.new(file, to_file)
      command = base.frame_grab '00:10:23'
      expect(command).to be_a Array
      expect(command.join(' ')).to include '-ss 00:10:23'
    end 
  end
  
  context '.perform' do
    it 'returns false no command to give' do
      base = described_class.new(file, to_file)
      expect(base.perform).to be false 
    end

    it 'returns true command should run' do
      base = described_class.new(file, to_file)
      command = base.command do 
        frames 1 
        frame_grab
        size 400,400
        disable_audio! 
      end 
      expect(base.perform).to be true
    end 
  end
end 

