require 'rails_helper'

RSpec.describe FFMPEG::Base, type: :model do
  let(:file) { Rails.root.join('spec','fixtures', 'files', 'test.mov')  }
  let(:to_file) { Rails.root.join('tests', 'data', 'files', 'test.mp4') }

  context '.init' do
    it 'should set the @file' do
      base = described_class.new(file, to_file)
      expect(base.instance_variable_defined?(:@file)).to be true
    end

    it 'should set the @to_file' do
      base = described_class.new(file, to_file)
      expect(base.instance_variable_defined?(:@to_file)).to be true
    end

    it 'should set the @options' do
      base = described_class.new(file, to_file)
      expect(base.instance_variable_defined?(:@options)).to be true
    end

    it 'should set the @command' do
      base = described_class.new(file, to_file)
      expect(base.instance_variable_defined?(:@command)).to be true
    end
  end 

  context '.valid_options' do
    it 'should set the file with a hash if nothing is supplied' do
      base = described_class.new(file, to_file)
      expect(base.valid_options).to be true
    end 

    failing_types = [
      'Something', 
      ['some', 'cool', 'thing'], 
      12, 
      nil, 
      ''
    ]
    failing_types.each do |option| 
      it "should fail with any other data type such as: #{option.class}" do 
        base = described_class.new(file, to_file, option)
        expect { base.valid_options }.to raise_error(ArgumentError, "Options '#{option.class}', should be a Hash.")
      end
    end  
  end 

  context '.valid_file' do
    it 'should pass because the file path is a valid path' do 
      base = described_class.new(file, to_file)
      expect(base.valid_file).to be true
    end 

    it 'should fail not a valid path' do 
      base = described_class.new(nil, to_file)
      expect { base.valid_file }.to raise_error(ArgumentError, "Input file should be a type of file, or pathname.")
    end 

    it 'should fail with non existing file' do 
      file = Rails.root.join('spec','fixtures', 'files', 'waldorTheGreat.mov')
      base = described_class.new(file, to_file)
      expect { base.valid_file }.to raise_error(ArgumentError, "Input file needs to be a file that exists.")
    end 
  end

  context '.valid_output' do
    correct_types = ["/test/something/cool", Rails.root.join('spec', 'fixtures')]
    correct_types.each do |type| 
      it "should pass with proper type:: #{type}" do
        base = described_class.new(file, to_file)
        expect(base.valid_output).to be true
      end 
    end 

    it 'should not have valid output' do
      base = described_class.new(file, nil)
      expect { base.valid_output }.to raise_error(ArgumentError, 'Output Path is a not the correct types and needs to be a path or string.')
    end
  end

  context '.filename' do
    it 'sends a filename back' do 
      base = described_class.new(file, to_file)
      expect(base.filename).to be_a String
      expect(base.filename).to eq 'test'
    end 
  end
  

  context '.path_or_string' do
    correct_types = ["/test/something/cool", Rails.root.join('spec', 'fixtures')]
    correct_types.each do |type| 
      it "should pass with proper type:: #{type}" do
        base = described_class.new(file, to_file)
        expect(base.path_or_string?(type)).to be true
      end 
    end 

    failure_types = [ 
      1, 
      ['soemthing', 'cool'], 
      { soemthing: Rails.root.join('spec') }
    ]

    failure_types.each do |type| 
      it "should fail with imporper type :: #{type}" do
        base = described_class.new(file, to_file)
        expect(base.path_or_string?(type)).to be false
      end 
    end 
  end
  
  context '.ffmpeg_path' do
    it 'expects a string' do 
      base = described_class.new(file, to_file)
      expect(base.ffmpeg_path).to be_a String
    end     

    it 'expects the string to contain ffmpeg' do 
      base = described_class.new(file, to_file)
      expect(base.ffmpeg_path).to include 'ffmpeg'
    end 
  end
end 

