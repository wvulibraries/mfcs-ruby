require 'rails_helper'

RSpec.describe Validator::NoSpace, type: :model do
  # shared examples
  context 'base behaviors' do
    it_behaves_like 'a validator object' 
  end

  context '.perform' do
    it 'should return false the string has spaces' do
      str = ' sme string with spaces '
      base = described_class.new(str, {}, 1)
      expect(base.perform).to be false
    end
    
    it 'should return true the string has no spaces' do
      str = 'as;dlfkjas;dflkjasd;lfkjasd;f'
      base = described_class.new(str, {}, 1)
      expect(base.perform).to be true
    end
  end
end 