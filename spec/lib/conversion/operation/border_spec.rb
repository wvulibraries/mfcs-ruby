require 'rails_helper'

RSpec.describe Conversion::Operation::Border, type: :model do
  let(:form) { FactoryBot.build_stubbed(:file_conversion_form) }
  let(:stubbed_media) { FactoryBot.build_stubbed(:media) }
  let(:media) { FactoryBot.create(:media) }

  context '.init' do 
    it 'initalizes' do
      params_hash = form.organized_hash[:files]
      base = described_class.new(params_hash)
      expect(base).to be_a described_class
    end

    it "assigned @border_width" do
      params_hash = form.organized_hash[:files]
      base = described_class.new(params_hash)
      expect(base.instance_variable_defined?(:@border_width)).to be true
    end

    it "assigned @border_color" do
      params_hash = form.organized_hash[:files]
      base = described_class.new(params_hash)
      expect(base.instance_variable_defined?(:@border_color)).to be true
    end
  end 

  context 'defaults' do
    it 'expects default @border_width' do
      params_hash = form.organized_hash[:files]
      params_hash['border_width'] = nil
      base = described_class.new(params_hash)
      expect(base.instance_variable_get('@border_width')).to eq '5px'
    end 

    it 'expects passed value @border_width' do
      params_hash = form.organized_hash[:files]
      params_hash['border_width'] = '3px'
      base = described_class.new(params_hash)
      expect(base.instance_variable_get('@border_width')).to eq '3px'
    end 

    it 'expects default @border_color' do
      params_hash = form.organized_hash[:files]
      params_hash['border_color'] = nil
      base = described_class.new(params_hash)
      expect(base.instance_variable_get('@border_color')).to eq '#000000'
    end 

    it 'expects passed value @border_width' do
      params_hash = form.organized_hash[:files]
      params_hash['border_color'] = '#fff333'
      base = described_class.new(params_hash)
      expect(base.instance_variable_get('@border_color')).to eq '#fff333'
    end 
  end 

  context 'self.matches?' do
    it 'matches' do 
      params_hash = form.organized_hash[:files]
      params_hash['border'] = true
      expect(described_class.matches?(params_hash)).to be true
    end 

    it 'does not match' do 
      params_hash = form.organized_hash[:files]
      params_hash['border'] = false
      expect(described_class.matches?(params_hash)).to be false
    end 
  end
  
  context '.call' do
    it 'stubs the call method to work somewhat properly' do 
      params_hash = form.organized_hash[:files]
      # set up a dummy conversion object
      convert_object = double() 
      allow(convert_object).to receive(:border).and_return(true)
      allow(convert_object).to receive(:bordercolor).and_return(true)
      # run the test to make sure it comes back truthyish
      base = described_class.new(params_hash)
      expect(base.call(convert_object)).to be_truthy
    end 
  end 
end 