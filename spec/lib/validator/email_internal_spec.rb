require 'rails_helper'

RSpec.describe Validator::EmailInternal, type: :model do
  # shared examples
  context 'base behaviors' do
    it_behaves_like 'a validator object' 
  end
  
  context 'methods' do
    before(:each) do
      @base =  described_class.new('test_input', {'testing': 'soemthing here'}, 1)
    end

    it 'should respond to email of parent class' do
      expect(@base).respond_to? :email
    end   

    it 'should respond to email_internal' do
      expect(@base).respond_to? :email_internal
    end 
  end
  
  context '.perform' do
    it 'returns true for nil' do
      email = nil
      base = described_class.new(email, {}, 1)
      expect(base.perform).to be true
    end

    it 'returns true for empty' do
      email = ''
      base = described_class.new(email, {}, 1)
      expect(base.perform).to be true
    end
    
    it 'valid email, but not internal' do
      base = described_class.new(Faker::Internet.free_email, {}, 1)
      expect(base.perform).to be false
    end

    it 'valid wvu email old' do
      base = described_class.new('jjjameson@wvu.edu', {}, 1)
      expect(base.perform).to be true
    end

    it 'valid wvu email new' do
      base = described_class.new('jjjameson@mail.wvu.edu', {}, 1)
      expect(base.perform).to be true
    end
  end

  context '.email_internal' do
    it 'valid email, but not internal' do
      email = Faker::Internet.free_email
      base = described_class.new(email, {}, 1)
      expect(base.email_internal(email)).to be false
    end

    it 'valid wvu email old' do
      email = 'jjjameson@wvu.edu'
      base = described_class.new(email, {}, 1)
      expect(base.email_internal(email)).to be true
    end

    it 'valid wvu email new' do
      email = 'jjjameson@mail.wvu.edu'
      base = described_class.new(email, {}, 1)
      expect(base.email_internal(email)).to be true
    end
  end
end 