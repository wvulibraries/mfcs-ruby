require 'rails_helper'

RSpec.describe Conversion::Image, type: :model do
  let(:form) { FactoryBot.build_stubbed(:file_conversion_form) }
  let(:stubbed_media) { FactoryBot.build_stubbed(:media) }
  let(:media) { FactoryBot.create(:media) }

  context '.init' do 
    it 'initalizes' do
      params_hash = form.organized_hash[:files]
      base = described_class.new(media.id, params_hash)
      expect(base).to be_a described_class
    end

    it "assigned @field_id" do
      params_hash = form.organized_hash[:files]
      base = described_class.new(media.id, params_hash)
      expect(base.instance_variable_defined?(:@media)).to be true
    end

    it "sets up the @operations array" do 
      params_hash = form.organized_hash[:files]
      base = described_class.new(media.id, params_hash)
      expect(base.instance_variable_defined?(:@operations)).to be true
    end 
  end 

  context '.save_file' do
    it 'should create a saveable file path with format and filename' do
      params_hash = form.organized_hash[:files]
      base = described_class.new(media.id, params_hash)
      expect(base.save_file).to be_a Pathname
    end 

    it 'should end as a png' do
      params_hash = form.organized_hash[:files]
      params_hash['image_format'] = 'png'
      base = described_class.new(media.id, params_hash)
      expect(base.save_file.basename.to_s).to  eq 'test_image_1.png'
    end 

    it 'should create a jpg if no format is given' do
      params_hash = form.organized_hash[:files]
      params_hash['image_format'] = nil
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
      base = described_class.new(media.id, params_hash)
      result = base.perform
      expect(result).to be_truthy 
    end 
  end 
end 