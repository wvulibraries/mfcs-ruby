require 'rails_helper'

RSpec.describe Conversion::Image, type: :model do
  let(:form) { FactoryBot.build_stubbed(:file_conversion_form) }
  let(:stubbed_media) { FactoryBot.build_stubbed(:media) }
  let(:media) { FactoryBot.create(:media) }
  let(:watermark) { FactoryBot.create :watermark }

  data = JSON.parse(File.read(Rails.root.join("spec/fixtures/files/mimes_hash.json")))

  context '.matches?' do
    data['image'].sample(10).each do |mime| 
      it "#{mime} should pass the matcher." do
        expect(described_class.matches?(mime)).to be true
      end 
    end 

    data['audio'].sample(10).each do |mime| 
      it "#{mime} fails the matcher wrong file type" do
        expect(described_class.matches?(mime)).to be false
      end 
    end 
  end

  context '.init' do 
    it 'initalizes' do
      params_hash = form.organized_hash[:files]
      params_hash['watermark'] = false
      base = described_class.new(media.id, params_hash)
      expect(base).to be_a described_class
    end

    it "assigned @field_id" do
      params_hash = form.organized_hash[:files]
      params_hash['watermark'] = false
      base = described_class.new(media.id, params_hash)
      expect(base.instance_variable_defined?(:@media)).to be true
    end

    it "sets up the @operations array" do 
      params_hash = form.organized_hash[:files]
      params_hash['watermark'] = false
      base = described_class.new(media.id, params_hash)
      expect(base.instance_variable_defined?(:@operations)).to be true
    end 
  end 

  context '.save_file' do
    it 'should create a saveable file path with format and filename' do
      params_hash = form.organized_hash[:files]
      params_hash['watermark'] = false
      base = described_class.new(media.id, params_hash)
      expect(base.save_file).to be_a Pathname
    end 

    it 'should end as a png' do
      params_hash = form.organized_hash[:files]
      params_hash['image_format'] = 'png'
      params_hash['watermark'] = false
      base = described_class.new(media.id, params_hash)
      expect(base.save_file.basename.to_s).to  eq 'test_image_1.png'
    end 

    it 'should create a jpg if no format is given' do
      params_hash = form.organized_hash[:files]
      params_hash['image_format'] = nil
      params_hash['watermark'] = false
      base = described_class.new(media.id, params_hash)
      expect(base.save_file.basename.to_s).to  eq 'test_image_1.jpg'
    end
  end 

  context 'constants' do
    it 'should have a constant of operations' do
      expect(Conversion::Image::OPERATIONS).to be_an Array
    end 
  end

  context '.perform' do 
    it 'should create the image' do
      params_hash = form.organized_hash[:files]
      params_hash['watermark'] = false
      base = described_class.new(media.id, params_hash)
      result = base.perform
      expect(result).to be_truthy 
    end 

    it 'should perform with a watermark and be truthy' do 
      params_hash = form.organized_hash[:files]
      params_hash['watermark'] = true
      params_hash['watermark_image'] = watermark.id 
      params_hash['watermark_location'] = 'East'

      base = described_class.new(media.id, params_hash)
      result = base.perform
      expect(result).to be_truthy 
    end 
  end 
end 