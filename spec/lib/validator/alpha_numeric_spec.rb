require 'rails_helper'

RSpec.describe Validator::AlphaNumeric, type: :model do
  # shared examples
  context 'base behaviors' do
    it_behaves_like 'a validator object' 
  end

  context '.perform' do
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
    
    it 'likes alphabets with spaces' do
      str = 'AlphaNumerical0003754'
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