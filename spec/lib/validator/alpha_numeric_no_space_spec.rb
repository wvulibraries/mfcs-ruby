require 'rails_helper'

RSpec.describe Validator::AlphaNumericNoSpace, type: :model do
  
  context 'base behaviors' do
    it_behaves_like 'a validator object' 
  end

  context '.perform' do
    it 'should return true empty values because there is nothing to evaluate' do
      str = ''
      base = described_class.new(str, {}, 1)
      expect(base.perform).to be true
    end 

    it 'should return true nil because there is nothing to evaluate' do
      str = nil
      base = described_class.new(str, {}, 1)
      expect(base.perform).to be true
    end 

    it 'does not like scripty shenanigans' do
      str = "Somealpha823stuff\n<script>alert('pwned')</script>"
      base = described_class.new(str, {}, 1)
      expect(base.perform).to be false
    end

    it 'does not like other characters' do
      str = 'Some!_.asdf;'
      base = described_class.new(str, {}, 1)
      expect(base.perform).to be false
    end 
    
    it 'likes alphabets with no spaces' do
      str = 'AlphaNumerical0003754'
      base = described_class.new(str, {}, 1)
      expect(base.perform).to be true
    end

    it 'does not like alphabets and numerical with spaces' do
      str = 'AlphaNumerical 0003754'
      base = described_class.new(str, {}, 1)
      expect(base.perform).to be false
    end

    it 'likes numerical' do
      str = '8234985'
      base = described_class.new(str, {}, 1)
      expect(base.perform).to be true
    end
  end
end 