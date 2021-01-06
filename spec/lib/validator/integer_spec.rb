require 'rails_helper'

RSpec.describe Validator::Integer, type: :model do
  # shared examples
  context 'base behaviors' do
    it_behaves_like 'a validator object' 
  end

  context 'methods' do
    it 'should respond integer method' do
      expect(@base).respond_to? :integer
    end   
  end

  context '.perform -> .integer' do
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
    
    ['3000000', 3000, 3.08425].each do |int| 
      it "valid ints -- #{int}" do
        base = described_class.new(int, {}, 1)
        expect(base.perform).to be true
      end
    end 
      
    it 'invalid int because of spaces' do
      base = described_class.new('300000 0000', {}, 1)
      expect(base.perform).to be false
    end 

    it 'invalid int because of characters' do
      base = described_class.new('300000asdfads0000', {}, 1)
      expect(base.perform).to be false
    end 
  end
end 