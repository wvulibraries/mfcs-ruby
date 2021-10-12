require 'rails_helper'

RSpec.describe Conversion::Operation::WatermarkOverlay, type: :model do
  let(:form) { FactoryBot.build_stubbed(:file_conversion_form) }
  let(:stubbed_media) { FactoryBot.build_stubbed(:media) }
  let(:media) { FactoryBot.create(:media) }
  let(:file) { Rails.root.join('spec','fixtures', 'files', 'test_image_1.jpg') }
  let(:test_file_dir) { Rails.root.join('tests', 'data', 'watermarks', 'files') }
  let(:watermark) { FactoryBot.create :watermark }

  context 'self.matches?' do
    # it always matches as an FYI
    it 'does not match' do 
      params_hash = form.organized_hash[:files]
      params_hash['watermark'] = nil
      expect(described_class.matches?(params_hash)).to be false
    end 

    # it always matches as an FYI
    it 'does not match' do 
      params_hash = form.organized_hash[:files]
      params_hash['watermark'] = false
      expect(described_class.matches?(params_hash)).to be false
    end 

    it 'matches' do 
      params_hash = form.organized_hash[:files]
      params_hash['watermark'] = true
      expect(described_class.matches?(params_hash)).to be true
    end 
  end

  context '.init' do 
    it 'initalizes' do
      params_hash = form.organized_hash[:files]
      base = described_class.new(file, params_hash, media)
      expect(base).to be_a described_class
    end

    it "assigned @file_path" do
      params_hash = form.organized_hash[:files]
      base = described_class.new(file, params_hash, media)
      expect(base.instance_variable_defined?(:@file_path)).to be true
    end

    it 'assignes @watermark_id' do
      params_hash = form.organized_hash[:files]
      base = described_class.new(file, params_hash, media)
      expect(base.instance_variable_defined?(:@watermark_id)).to be true
    end 

    it 'assignes @location' do
      params_hash = form.organized_hash[:files]
      base = described_class.new(file, params_hash, media)
      expect(base.instance_variable_defined?(:@location)).to be true
    end 
  end   

  context '.watermark_image' do
    it 'should have a watermark image and return a minimagick object' do
      params_hash = form.organized_hash[:files] 
      params_hash['watermark_image'] = watermark.id 
      base = described_class.new(file, params_hash, media)
      expect(base.watermark_image).to be_a MiniMagick::Image
    end 

    it 'provided a nil watermark, it finds one anyway' do
      watermark # init a watermark so that one exists
      params_hash = form.organized_hash[:files] 
      params_hash['watermark_image'] = nil
      base = described_class.new(file, params_hash, media)
      expect(base.watermark_image).to be_a MiniMagick::Image
    end 

    it 'provided an empty watermark, it finds one anyway' do
      watermark # init a watermark so that one exists
      params_hash = form.organized_hash[:files] 
      params_hash['watermark_image'] = ''
      base = described_class.new(file, params_hash, media)
      expect(base.watermark_image).to be_a MiniMagick::Image
    end 

    it 'provided an non existant ID, it finds one anyway' do
      watermark # init a watermark so that one exists
      params_hash = form.organized_hash[:files] 
      params_hash['watermark_image'] = 999
      base = described_class.new(file, params_hash, media)
      expect(base.watermark_image).to be_a MiniMagick::Image
    end 
  end 

  context '.perform' do
    before(:each) do
      FileUtils.mkdir_p(test_file_dir) unless File.exists?(test_file_dir)
      filename = File.basename(file) 
      new_location = "#{test_file_dir}/#{filename}"
      FileUtils.cp(file, new_location)
      @test_file = new_location 
    end 

    it 'should return truthy' do 
      params_hash = form.organized_hash[:files]
      params_hash['watermark'] = true
      params_hash['watermark_image'] = watermark.id 
      params_hash['watermark_location'] = 'East'
      base = described_class.new(@test_file, params_hash, media)
      expect(base.perform).to be_truthy
    end 
  end 
end 