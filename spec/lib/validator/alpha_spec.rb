require 'rails_helper'

RSpec.describe Validator::Alpha, type: :model do
  # shared examples
  context 'base behaviors' do
    it_behaves_like 'a validator object' 
  end
  
  context '.perform' do
    it 'hates alpha with spaces' do
      str = 'something cool spaces'
      base = described_class.new(str, {}, 1)
      expect(base.perform).to be false
    end

    it 'likes all alpha with no spaces' do
      str = 'somethingCoolMan'
      base = described_class.new(str, {}, 1)
      expect(base.perform).to be true
    end

    it 'hates punctuation marks' do
      str = 'somethingcool.'
      base = described_class.new(str, {}, 1)
      expect(base.perform).to be false
    end

    it 'hates numbers' do
      str = 'idonotlikenumbers284'
      base = described_class.new(str, {}, 1)
      expect(base.perform).to be false
    end
  end  
end 