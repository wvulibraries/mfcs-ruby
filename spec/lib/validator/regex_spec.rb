require 'rails_helper'

RSpec.describe Validator::Regex, type: :model do
  let(:field_hash) do 
    field_hash = {"max"=>"", "min"=>"", "name"=>"title", "step"=>"", "type"=>"text", "label"=>"AcquisitionTitle", "value"=>"", "css_id"=>"title", "format"=>"characters", "hidden"=>"", "disabled"=>"false", "field_id"=>"0", "help_url"=>"", "readonly"=>"false", "required"=>"true", "sortable"=>"", "css_class"=>"", "help_info"=>"", "help_type"=>"no_help", "searchable"=>"", "sort_order"=>"0", "validation"=>"", "placeholder"=>"", "local_styles"=>"width:90%;", "no_duplicates"=>"true", "public_release"=>"true", "display_in_list"=>"", "validation_regex"=>"", "disabled_on_insert"=>"false", "disabled_on_update"=>"false", "metadata_standards"=>[]}
  end 
  # shared examples
  context 'base behaviors' do
    it_behaves_like 'a validator object' 
  end

  context '.perform' do
    it 'should return true for the matching expression' do
      field_hash['validation'] = 'regex'
      field_hash['validation_regex'] = '/\s/'
      str = 'something cool'
      base = described_class.new(str, field_hash, 1)
      expect(base.perform).to be true
    end 

    it 'should return false because it is not a string of whitespaces' do
      field_hash['validation'] = 'regex'
      field_hash['validation_regex'] = '/^\S*$/'
      str = 'something cool'
      base = described_class.new(str, field_hash, 1)
      expect(base.perform).to be false
    end 
  end
end 