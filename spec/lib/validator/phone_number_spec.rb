require 'rails_helper'

RSpec.describe Validator::PhoneNumber, type: :model do
  # shared examples
  context 'base behaviors' do
    it_behaves_like 'a validator object' 
  end
  
  context '.perform' do
    
    it 'returns true for empty' do
      n = ''
      dv = described_class.new(n, {}, 1)
      expect(dv.perform).to be true
    end

    it 'returns true for nil' do
      n = nil
      dv = described_class.new(n, {}, 1)
      expect(dv.perform).to be true
    end
    

    valid_numbers = [
      '(333)111-2385',
      '333-111-2385',
      '333.111.2385',
      '333 111 2385',
      '(333) 111-2385',
      '(333).111.2385',
      '(333) 111 2385',
      '(333)111.2385',
      '1-230-234-2356'
    ]

    valid_numbers.each do |n|
      it "valid phone number -- #{n}" do
        dv = described_class.new(n, {}, 1)
        expect(dv.perform).to be true
      end
    end

    invalid_numbers = [
      '123.234.123',
      'joe',
      '123-234-1234x',
      '1-230-234-2356x'
    ]
    
    invalid_numbers.each do |n|
      it "invalid phone number -- #{n}" do
        dv = described_class.new(n, {}, 1)
        expect(dv.perform).to be false
      end
    end
  end
end 