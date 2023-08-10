require 'rails_helper'

RSpec.describe Validator::OptionalUrl, type: :model do
  # shared examples
  context 'base behaviors' do
    it_behaves_like 'a validator object' 
  end

  context 'methods' do
    it 'should respond integer method' do
      expect(@base).respond_to? :url
    end   
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
    
    valid_options = [ 
      Faker::Internet.url, 
      'ftp://ftpserver.com/path/to/image.png',
      'ssh://user@host.example.com',
      'ssh://user@host.example.com:2222',
      'telnet://something.com',
      'https://www.google.com/?q=test&p=something', 
      '',
      nil
    ]

    valid_options.each do |input|
      it "valid url -- #{input}" do
        base = described_class.new(input, {}, 1)
        expect(base.perform).to be true
      end
    end

    invalid_options = [
      'www.foo.com', 
      'http:/www.google.com', 
      'test'
    ]

    invalid_options.each do |input|
      it "invalid url -- #{input}" do
        base = described_class.new(input, {}, 1)
        expect(base.perform).to be false
      end
    end
  end 
end 