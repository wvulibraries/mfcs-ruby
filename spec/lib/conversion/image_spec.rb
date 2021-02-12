require 'rails_helper'

RSpec.describe Conversion::Image, type: :model do
  let(:item) { FactoryBot.build_stubbed(:file_conversion_form) }
  let(:stubbed_media) { FactoryBot.build_stubbed(:media) }
  let(:media) { FactoryBot.create(:media) }

  context '.init' do 
    it 'initalizes' do
      base = described_class.new(media.id)
      expect(base).to be_a described_class
    end

    it "assigned @field_id" do
      base = described_class.new(media.id)
      expect(base.instance_variable_defined?(:@archived_media)).to be true
    end
  end 

  context 'constants' do
    it 'should have a constant that is an array with a count of 18' do
      expect(Conversion::Image::IMAGE_PARAMS).to be_an Array
      expect(Conversion::Image::IMAGE_PARAMS.count).to eq 18
    end 
  end

  context '.conversion_params' do
    it 'should be a hash' do
      base = described_class.new(media.id) 
      expect(base.conversion_params).to be_a Hash
    end 

    it 'should contain the fields set in the params constant' do
      base = described_class.new(media.id) 
      expect(base.conversion_params.values.count).to eq 18
    end 
  end

  context '.border?' do
    it 'should be true' do
      base = described_class.new(media.id) 
      expect(base.border?).to be true
    end 

    it 'should be false border not added' do
      form = media.item.form 
      form[:fields].each do |field|
        field['border'] = false
      end  
      form.save

      base = described_class.new(media.id) 
      expect(base.border?).to be false
    end 

    it 'should be false border color nil' do 
      form = media.item.form 
      form[:fields].each do |field|
        field['border_color'] = nil
      end  
      form.save

      base = described_class.new(media.id) 
      expect(base.border?).to be false
    end 

    it 'should be false border width nil' do 
      form = media.item.form 
      form[:fields].each do |field|
        field['border_width'] = nil
      end  
      form.save

      base = described_class.new(media.id) 
      expect(base.border?).to be false
    end 
  end 


end 