require 'rails_helper'

RSpec.describe Validator::FieldValidations, type: :model do
  let(:field_hash) do 
    field_hash = {"max"=>"", "min"=>"", "name"=>"title", "step"=>"", "type"=>"text", "label"=>"AcquisitionTitle", "value"=>"", "css_id"=>"title", "format"=>"characters", "hidden"=>"", "disabled"=>"false", "field_id"=>"0", "help_url"=>"", "readonly"=>"false", "required"=>"true", "sortable"=>"", "css_class"=>"", "help_info"=>"", "help_type"=>"no_help", "searchable"=>"", "sort_order"=>"0", "validation"=>"", "placeholder"=>"", "local_styles"=>"width:90%;", "no_duplicates"=>"true", "public_release"=>"true", "display_in_list"=>"", "validation_regex"=>"", "disabled_on_insert"=>"false", "disabled_on_update"=>"false", "metadata_standards"=>[]}
  end 

  context 'validations' do
    it 'responds to this method' do
      base = described_class.new(field_hash)
      expect(base).respond_to? :validations
    end

    it 'expects validations to return as an array' do
      base = described_class.new(field_hash)
      expect(base.validations).to be_an Array
    end 

    # Note this test was orginally set to have a count of 3
    # needs further invistagation to see if it is correct to
    # be set at 4. tam - 06/21/21
    it 'expects the number of validations to be 4' do
      field_hash['min'] = 1
      field_hash['max'] = 200 
      field_hash['type'] = 'text'
      field_hash['format'] = 'characters'
      field_hash['validation'] = 'something'
      field_hash['no_duplicates'] = true
      field_hash['required'] = true
      base = described_class.new(field_hash)
      expect(base.validations.count).to eq 4
    end 

    it 'expects the number of validations to be 2' do
      field_hash['min'] = ''
      field_hash['max'] = ''
      field_hash['type'] = 'number'
      field_hash['min_number'] = '1'
      field_hash['max_number'] = '100'
      field_hash['step'] = 3
      field_hash['required'] = false
      field_hash['validation'] = ''
      base = described_class.new(field_hash)
      expect(base.validations.count).to eq 2
    end 

    it 'expects the number of validations to be 1' do
      field_hash['min'] = ''
      field_hash['max'] = ''
      field_hash['type'] = 'idno'
      field_hash['min_number'] = ''
      field_hash['max_number'] = ''
      field_hash['step'] = ''
      field_hash['required'] = false
      field_hash['validation'] = 'asdfasd'
      base = described_class.new(field_hash)
      expect(base.validations.count).to eq 1
    end 
  end
  
  context '.text_validation?' do
    it 'responds to this method' do
      base = described_class.new(field_hash)
      expect(base).respond_to? :text_validation?
    end

    it 'expects true type matches and min/max present' do
      field_hash['min'] = 1
      field_hash['max'] = 200 
      field_hash['type'] = 'text'
      base = described_class.new(field_hash)
      expect(base.text_validation?).to be true
    end

    it 'wrong type should be false' do
      field_hash['type'] = 'number'
      base = described_class.new(field_hash)
      expect(base.text_validation?).to be false
    end

    it 'no min/max values should be false' do
      field_hash['type'] = 'text'
      field_hash['min'] = ''
      field_hash['max'] = ''
      base = described_class.new(field_hash)
      expect(base.text_validation?).to be false
    end
  end

  context '.integer_validation?' do
    it 'responds to this method' do
      base = described_class.new(field_hash)
      expect(base).respond_to? :integer_validation?
    end    

    it 'returns true type and min/max numbers are there' do
      field_hash['type'] = 'number'
      field_hash['min_number'] = '1'
      field_hash['max_number'] = '200'
      base = described_class.new(field_hash)
      expect(base.integer_validation?).to be true
    end

    it 'wrong type returns false' do
      field_hash['type'] = 'text'
      field_hash['min_number'] = '1'
      field_hash['max_number'] = '200'
      base = described_class.new(field_hash)
      expect(base.integer_validation?).to be false
    end

    it 'no validation needed' do
      field_hash['type'] = 'integer'
      field_hash['min_number'] = ''
      field_hash['max_number'] = ''
      base = described_class.new(field_hash)
      expect(base.integer_validation?).to be false
    end
  end

  context '.step_validation?' do
    it 'responds to this method' do
      base = described_class.new(field_hash)
      expect(base).respond_to? :step_validation?
    end    

    it 'returns true type and min/max numbers are there' do
      field_hash['type'] = 'number'
      field_hash['step'] = 1
      base = described_class.new(field_hash)
      expect(base.step_validation?).to be true
    end

    it 'wrong type returns false' do
      field_hash['type'] = 'text'
      field_hash['step'] = 1
      base = described_class.new(field_hash)
      expect(base.step_validation?).to be false
    end

    it 'no validation needed' do
      field_hash['type'] = 'integer'
      field_hash['step'] = ''
      base = described_class.new(field_hash)
      expect(base.step_validation?).to be false
    end
  end 

  context '.validation?' do
    it 'responds to this method' do
      base = described_class.new(field_hash)
      expect(base).respond_to? :validation?
    end    

    it 'returns true a validation is present' do
      field_hash['validation'] = 'something'
      base = described_class.new(field_hash)
      expect(base.validation?).to be true
    end 

    it 'returns false there is no validation to be performed' do
      field_hash['validation'] = ''
      base = described_class.new(field_hash)
      expect(base.validation?).to be false
    end 
  end

  context '.duplicates?' do
    it 'responds to this method' do
      base = described_class.new(field_hash)
      expect(base).respond_to? :duplicates?
    end    

    it 'returns true duplicates need to be checked' do
      field_hash['no_duplicates'] = true 
      field_hash['required'] = 'true'
      base = described_class.new(field_hash)
      expect(base.duplicates?).to be true
    end 

    it 'returns false duplicates not to be checked' do
      field_hash['no_duplicates'] = true 
      field_hash['required'] = 'false'
      base = described_class.new(field_hash)
      expect(base.duplicates?).to be false
    end 

    it 'returns false duplicates not to be checked' do
      field_hash['no_duplicates'] = false 
      field_hash['required'] = true
      base = described_class.new(field_hash)
      expect(base.duplicates?).to be false
    end 
  end
  
end 
