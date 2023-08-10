require 'rails_helper'

RSpec.describe Validator::Required, type: :model do
  # shared examples
  context 'base behaviors' do
    it_behaves_like 'a validator object' 
  end

  let(:field_hash) do 
    {"max"=>"", "min"=>"", "name"=>"title", "type"=>"text", "label"=>"Title", "value"=>"", "css_id"=>"", "format"=>"characters", "hidden"=>false, "disabled"=>false, "field_id"=>"9439454999752343", "help_url"=>"", "required"=>true, "sortable"=>true, "css_class"=>"", "help_info"=>"", "help_type"=>"", "read_only"=>false, "searchable"=>true, "sort_order"=>"2", "validation"=>"", "oai_release"=>false, "placeholder"=>"", "local_styles"=>"", "no_duplicates"=>false, "public_release"=>true, "display_in_list"=>false, "validation_regex"=>"", "disabled_on_insert"=>false, "disabled_on_update"=>false, "metadata_standards"=>""}
  end

  context '.perform' do
    valid_cases = ['data', ['some', 'data'], {test: 'data'}, 1]
    valid_cases.each do |valid| 
      it "should return true for these valid #{valid}" do
        req = described_class.new(valid, {}, 1)
        expect(req.perform).to be true
      end 
    end 

    it 'is false for nil' do
      req = described_class.new(nil, {}, 1)
      expect(req.perform).to be false
    end 

    it 'is false for empty string' do
      req = described_class.new('', {}, 1)
      expect(req.perform).to be false
    end 
  end 
end 