require 'rails_helper'

RSpec.describe Validator::Date, type: :model do
  # shared examples
  context 'base behaviors' do
    it_behaves_like 'a validator object' 
  end

  context '.perform' do
    it 'returns true for nil' do
      str = nil
      dv = described_class.new(str, {}, 1)
      expect(dv.perform).to be true
    end

    it 'return true for empty' do
      str = ''
      dv = described_class.new(str, {}, 1)
      expect(dv.perform).to be true
    end 
    
    valid_edtf = [ 
      '119x',
      '2001-02-03',
      '2008',
      '1964/2008',
      '2004-06/2006-08',
      '2004-02-01/2005-02-08',
      '2005/2006-02',
      '1984?',
      '2004-06?',
      '2004-06-11?',
      '1984~',
      '1984?~',
      '199u',
      '19uu',
      '1999-uu',
      '1999-01-uu',
      '1999-uu-uu',
      '2004-06-01/unknown',
      '2004-01-01/open',
      '1984~/2004-06',
      '1984/2004-06~',
      '1984?/2004?~',
      'y170000002',
      'y-170000002',
      '2001-21',
      '2011-(06-04)~',
      '2011-23~',
      '2004?-06-(11)~',
      '156u-12-25',
      '15uu-12-25',
      '[1667,1668,1670..1672]',
      '{1667,1668,1670..1672}',
      '{1960,1961-12}'
    ]

    valid_edtf.each do |e|
      it "validates edtf date - #{e}" do
        dv = described_class.new(e, {}, 1)
        expect(dv.perform).to be true
      end
    end

    invalid_edtf = [
      'joes',
      '1800jdks',
      '1991/32/32'
    ]

    invalid_edtf.each do |e|
      it "does not validate edtf - #{e}" do
        dv = described_class.new(e, {}, 1)
        expect(dv.perform).to be false
      end
    end

  end
end 