require 'rails_helper'

RSpec.describe Validator::IntegerStep, type: :model do
  let(:field_hash) do 
    field_hash = {"name"=>"UntitledNumberField", "step"=>"1", "type"=>"number", "label"=>"Untitled Number Field", "value"=>"", "css_id"=>"", "hidden"=>false, "disabled"=>false, "field_id"=>"9848220812499988", "help_url"=>"", "required"=>false, "sortable"=>false, "css_class"=>"", "help_info"=>"", "help_type"=>"", "read_only"=>false, "max_number"=>"100", "min_number"=>"1", "searchable"=>false, "sort_order"=>"3", "validation"=>"integer", "oai_release"=>false, "placeholder"=>"1", "local_styles"=>"", "no_duplicates"=>false, "public_release"=>true, "display_in_list"=>false, "validation_regex"=>"", "disabled_on_insert"=>false, "disabled_on_update"=>false, "metadata_standards"=>""}
  end 

  # shared examples
  context 'base behaviors' do
    it_behaves_like 'a validator object' 
  end

  context '.perform' do
    it 'Should validate true with 1' do
      field_hash['step'] = 1
      input = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
      base = described_class.new(input.sample, field_hash, 1)
      expect(base.perform).to be true
    end 

    it 'skips validation because nil value' do
      field_hash['step'] = nil
      base = described_class.new('10', field_hash, 1)
      expect(base.perform).to be true
    end 

    it 'true step is divisible' do
      field_hash['step'] = 2
      base = described_class.new('10', field_hash, 1)
      expect(base.perform).to be true
    end 

    it 'step is not divisible' do
      field_hash['step'] = 5 
      base = described_class.new('9', field_hash, 1)
      expect(base.perform).to be false
    end 
  end
end 