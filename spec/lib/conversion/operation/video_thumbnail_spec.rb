require 'rails_helper'

RSpec.describe Conversion::Operation::VideoThumbnail, type: :model do
  let(:form) { FactoryBot.build_stubbed(:file_conversion_form) }
  let(:media) { FactoryBot.create(:media) }
  let(:test_file_dir) { Rails.root.join('tests', 'data', 'files', 'thumbnail') }

  # Do this once to setup file location for testing
  before(:all) do
    test_file_dir = Rails.root.join('tests', 'data', 'files') 
    file = Rails.root.join('spec','fixtures', 'files', 'test_image_1.jpg') 
    filename = File.basename(file) 
    new_location = "#{test_file_dir}/#{filename}"

    FileUtils.mkdir_p(test_file_dir) unless File.exists?(test_file_dir)
    FileUtils.cp(file, new_location)

    @test_file = new_location 
  end 

  context 'self.matches?' do
    # it always matches as an FYI
    it 'does not match' do 
      params_hash = form.organized_hash[:files]
      params_hash['thumbnail'] = nil
      expect(described_class.matches?(params_hash)).to be false
    end 

    # it always matches as an FYI
    it 'does not match' do 
      params_hash = form.organized_hash[:files]
      params_hash['thumbnail'] = false
      expect(described_class.matches?(params_hash)).to be false
    end 

    it 'matches' do 
      params_hash = form.organized_hash[:files]
      params_hash['thumbnail'] = true
      expect(described_class.matches?(params_hash)).to be true
    end 
  end

  context '.init' do 
    it 'initalizes' do
      params_hash = form.organized_hash[:files]
      base = described_class.new(@test_file, params_hash, media)
      expect(base).to be_a described_class
    end

    it "assigned @file_path" do
      params_hash = form.organized_hash[:files]
      base = described_class.new(@test_file, params_hash, media)
      expect(base.instance_variable_defined?(:@file)).to be true
    end

    it 'assignes @height' do
      params_hash = form.organized_hash[:files]
      base = described_class.new(@test_file, params_hash, media)
      expect(base.instance_variable_defined?(:@height)).to be true
    end 

    it 'assignes @width' do
      params_hash = form.organized_hash[:files]
      base = described_class.new(@test_file, params_hash, media)
      expect(base.instance_variable_defined?(:@width)).to be true
    end 

    it 'assignes @resolution' do
      params_hash = form.organized_hash[:files]
      base = described_class.new(@test_file, params_hash, media)
      expect(base.instance_variable_defined?(:@resolution)).to be true
    end 

    it 'assignes @resolution' do
      params_hash = form.organized_hash[:files]
      base = described_class.new(@test_file, params_hash, media)
      expect(base.instance_variable_defined?(:@resolution)).to be true
    end 
  end   

  context '.thumb_path' do 
    it 'sets the thumb folder up in the current files parent folder' do
      params_hash = form.organized_hash[:files]
      base = described_class.new(@test_file, params_hash, media)
      expect(base.thumb_path).to be_a Pathname
    end 
  end

  context '.resolution' do
    it 'should default to 72 when thumbnail_resolution is not present' do
      params_hash = form.organized_hash[:files]

      # remove thumbnail_resolution field
      params_hash.delete('thumbnail_resolution')

      base = described_class.new(@test_file, params_hash, media)
      expect(base.resolution).to eq '72'
    end
  end


  context '.size' do
    it 'should be a string' do 
      params_hash = form.organized_hash[:files]
      base = described_class.new(@test_file, params_hash, media)
      expect(base.size).to be_a String
    end 

    it 'should be 300x300' do
      params_hash = form.organized_hash[:files]
      params_hash['thumbnail_height'] = nil 
      params_hash['thumbnail_width'] = nil
      base = described_class.new(@test_file, params_hash, media)
      expect(base.size).to eq '300x300'
    end   

    it 'should be 300x300 if thumbnail_height and thumbnail_width are missing' do
      params_hash = form.organized_hash[:files]
      params_hash.delete('thumbnail_height')
      params_hash.delete('thumbnail_width')
      base = described_class.new(@test_file, params_hash, media)
      expect(base.size).to eq '300x300'
    end       

    it 'should be 200x500' do
      params_hash = form.organized_hash[:files]
      params_hash['thumbnail_height'] = '500'
      params_hash['thumbnail_width'] = '200'
      base = described_class.new(@test_file, params_hash, media)
      expect(base.size).to eq '200x500'
    end 
  end 

  context '.save_file' do 
    it 'should be a pathname to the file' do
      params_hash = form.organized_hash[:files]
      base = described_class.new(@test_file, params_hash, media)
      expect(base.save_file).to be_a Pathname
    end 

    it 'should contain the file format' do 
      params_hash = form.organized_hash[:files]
      params_hash['thumbnail_format'] = 'png'
      base = described_class.new(@test_file, params_hash, media)
      expect(base.save_file.to_s).to include '.png'
    end 

    it 'should be a jpg given nil format' do 
      params_hash = form.organized_hash[:files]
      params_hash['thumbnail_format'] = nil
      base = described_class.new(@test_file, params_hash, media)
      expect(base.save_file.to_s).to include '.jpg'
    end 
  end 
  
  #context '.perform' do 
    # it 'should be a truthy result' do 
    #   params_hash = form.organized_hash[:files]
    #   base = described_class.new(@test_file, params_hash, media)
    #   expect(base.perform).to be_truthy
    # end 

    # it 'should save the media' do 
    #   params_hash = form.organized_hash[:files]
    #   base = described_class.new(@test_file, params_hash, media)
    #   expect(Media.count).to eq 1
    #   expect(base.perform).to be_truthy
    #   expect(Media.count).to eq 2
    # end 
  #end
  
  # context '.save_media' do
  #   before(:each) do
  #     FileUtils.mkdir_p(test_file_dir) unless File.exists?(test_file_dir)
  #   end 

  #   it 'should save the media' do 
  #     params_hash = form.organized_hash[:files]
  #     base = described_class.new(@test_file, params_hash, media)
  #     expect(Media.count).to eq 1
  #     expect(base.save_media).to be_truthy
  #     expect(Media.count).to eq 2
  #   end 
  # end 
end 