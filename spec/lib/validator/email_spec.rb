require 'rails_helper'

RSpec.describe Validator::Email, type: :model do
  # shared examples
  context 'base behaviors' do
    it_behaves_like 'a validator object' 
  end

  context 'methods' do
    it 'should respond to email of parent class' do
      expect(@base).respond_to? :email
    end   
  end

  context '.perform -> .email' do
    it 'valid email - manual' do
      base = described_class.new('test@test.com', {}, 1)
      expect(base.perform).to be true
    end

    it 'valid email - faker data' do
      base = described_class.new(Faker::Internet.free_email, {}, 1)
      expect(base.perform).to be true
    end

    it 'non-valid email' do
      base = described_class.new('f@il:com', {}, 1)
      expect(base.perform).to be false
    end
  end
end 