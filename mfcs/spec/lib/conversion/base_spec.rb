require 'rails_helper'

RSpec.describe Conversion::Base, type: :model do
  context '.perform' do
    it 'should raise an error' do 
     expect{ described_class.new.perform }.to raise_error(NoMethodError, 'Conversion::Base has not implemented the perform method.')
    end 
  end

  context '.save_media' do
    it 'should raise an error' do 
     expect{ described_class.new.save_media }.to raise_error(NoMethodError, 'Conversion::Base has not implemented the save_media method.')
    end 
  end

  context '.save_file' do
    it 'should raise an error' do 
     expect{ described_class.new.save_file }.to raise_error(NoMethodError, 'Conversion::Base has not implemented the save_file method.')
    end 
  end
end 