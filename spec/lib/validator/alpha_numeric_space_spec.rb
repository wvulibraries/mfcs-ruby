require 'rails_helper'

RSpec.describe Validator::AlphaNumericSpace, type: :model do
  # shared examples
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
      str = "Some alpha 823 stuff\n<script>alert('pwned')</script>"
      base = described_class.new(str, {}, 1)
      expect(base.perform).to be false
    end

    it 'does not like other characters' do
      str = 'Some alpha numerical with punctuation.'
      base = described_class.new(str, {}, 1)
      expect(base.perform).to be false
    end

    it 'likes alphabets with Space' do
      str = 'Alpha Numerical stuff'
      base = described_class.new(str, {}, 1)
      expect(base.perform).to be true
    end
    
    it 'likes alpha and numerical stuff' do
      str = 'Cat20485'
      base = described_class.new(str, {}, 1)
      expect(base.perform).to be true
    end 

    it 'likes alph numerical with Space' do
      str = 'Cat Number 12945'
      base = described_class.new(str, {}, 1)
      expect(base.perform).to be true
    end

    it 'likes numerical' do
      str = '8234985'
      base = described_class.new(str, {}, 1)
      expect(base.perform).to be true
    end
  end
end 