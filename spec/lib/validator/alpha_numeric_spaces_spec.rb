require 'rails_helper'

RSpec.describe Validator::AlphaNumericSpaces, type: :model do
  # shared examples
  context 'base behaviors' do
    it_behaves_like 'a validator object' 
  end

  context '.perform' do
    it 'does not like scripty shenanigans' do
      str = "Some alpha 823 stuff\n<script>alert('pwned')</script>"
      base = Validator::AlphaNumericSpaces.new(str, {}, 1)
      expect(base.perform).to be false
    end

    it 'does not like other characters' do
      str = 'Some alpha numerical with punctuation.'
      base = Validator::AlphaNumericSpaces.new(str, {}, 1)
      expect(base.perform).to be false
    end

    it 'likes alphabets with spaces' do
      str = 'Alpha Numerical stuff'
      base = Validator::AlphaNumericSpaces.new(str, {}, 1)
      expect(base.perform).to be true
    end
    
    it 'likes alpha and numerical stuff' do
      str = 'Cat20485'
      base = Validator::AlphaNumericSpaces.new(str, {}, 1)
      expect(base.perform).to be true
    end 

    it 'likes alph numerical with spaces' do
      str = 'Cat Number 12945'
      base = Validator::AlphaNumericSpaces.new(str, {}, 1)
      expect(base.perform).to be true
    end

    it 'likes numerical' do
      str = '8234985'
      base = Validator::AlphaNumericSpaces.new(str, {}, 1)
      expect(base.perform).to be true
    end
  end
end 