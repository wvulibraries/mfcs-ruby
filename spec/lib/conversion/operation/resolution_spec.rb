require 'rails_helper'

RSpec.describe Conversion::Operation::Resolution, type: :model do
  let(:form) { FactoryBot.build_stubbed(:file_conversion_form) }
  let(:stubbed_media) { FactoryBot.build_stubbed(:media) }
  let(:media) { FactoryBot.create(:media) }

  context '.init' do 
    it 'initalizes' do
      params_hash = form.organized_hash[:files]
      base = described_class.new(params_hash)
      expect(base).to be_a described_class
    end

    it "assigned @resolution" do
      params_hash = form.organized_hash[:files]
      base = described_class.new(params_hash)
      expect(base.instance_variable_defined?(:@resolution)).to be true
    end
  end 

  context 'defaults' do
    it 'expects resolution to be the default of 72' do
      params_hash = form.organized_hash[:files]
      params_hash['image_resolution'] = nil
      base = described_class.new(params_hash)
      expect(base.instance_variable_get('@resolution')).to eq 72
    end 

    it 'expects resolution to be the passed value' do
      params_hash = form.organized_hash[:files]
      params_hash['image_resolution'] = '90'
      base = described_class.new(params_hash)
      expect(base.instance_variable_get('@resolution')).to eq 90
    end 
  end 

  context 'self.matches?' do
    # it always matches as an FYI
    it 'matches' do 
      params_hash = form.organized_hash[:files]
      params_hash['image_resolution'] = nil
      expect(described_class.matches?(params_hash)).to be true
    end 

    it 'matches' do 
      params_hash = form.organized_hash[:files]
      params_hash['image_resolution'] = 90
      expect(described_class.matches?(params_hash)).to be true
    end 
  end
  
  context '.call' do
    it 'stubs the call method to work somewhat properly' do 
      params_hash = form.organized_hash[:files]
      # set up a dummy conversion object
      convert_object = double() 
      allow(convert_object).to receive(:density).and_return(true)
      # run the test to make sure it comes back truthyish
      base = described_class.new(params_hash)
      expect(base.call(convert_object)).to be_truthy
    end 
  end 
end 