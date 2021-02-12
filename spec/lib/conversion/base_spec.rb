require 'rails_helper'

RSpec.describe Conversion::Base, type: :model do
  let(:item) { FactoryBot.create(:complete_digital_object_user) }

  context '.init' do 
    it 'initalizes' do
      base = described_class.new(item.id)
      expect(base).to be_a described_class
    end

    it "assigned @field_id" do
      base = described_class.new(item.id)
      expect(base.instance_variable_defined?(:@item)).to be true
    end
  end 

  context 'Params' do 
    it '.image_param_keys' do
      base = described_class.new(item.id)
      expect(base).to respond_to(:image_param_keys) 
    end

    it '.video_param_keys' do
      base = described_class.new(item.id)
      expect(base).to respond_to(:video_param_keys) 
    end

    it '.audio_param_keys' do
      base = described_class.new(item.id)
      expect(base).to respond_to(:audio_param_keys) 
    end
  end 

end 