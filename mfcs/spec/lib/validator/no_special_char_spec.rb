require 'rails_helper'

RSpec.describe Validator::NoSpecialChar, type: :model do
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

    chars = '!@#$%^&*()_+{}|:">?<[]\\\';,.`~µñ©æáßðøäåé®þüúíóö'
    char_array = chars.split('')
    char_array.each do |char|
      it "does not like #{char} as a character" do
        str = "#{char}"
        base = described_class.new(str, {}, 1)
        expect(base.perform).to be false
      end
    end

    it 'likes this because no special characters' do
      str = "testing something"
      base = described_class.new(str, {}, 1)
      expect(base.perform).to be true
    end
  end
end 