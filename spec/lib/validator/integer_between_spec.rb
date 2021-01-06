require 'rails_helper'

RSpec.describe Validator::IntegerBetween, type: :model do
  let(:field_hash) do 
    field_hash = {"name"=>"UntitledNumberField", "step"=>"1", "type"=>"number", "label"=>"Untitled Number Field", "value"=>"", "css_id"=>"", "hidden"=>false, "disabled"=>false, "field_id"=>"9848220812499988", "help_url"=>"", "required"=>false, "sortable"=>false, "css_class"=>"", "help_info"=>"", "help_type"=>"", "read_only"=>false, "max_number"=>"100", "min_number"=>"1", "searchable"=>false, "sort_order"=>"3", "validation"=>"integer", "oai_release"=>false, "placeholder"=>"1", "local_styles"=>"", "no_duplicates"=>false, "public_release"=>true, "display_in_list"=>false, "validation_regex"=>"", "disabled_on_insert"=>false, "disabled_on_update"=>false, "metadata_standards"=>""}
  end 

  # shared examples
  context 'base behaviors' do
    it_behaves_like 'a validator object' 
  end

  context '.perform' do
    it 'should return true empty values because there is nothing to evaluate' do
      str = ''
      base = described_class.new(str, {}, 1)
      expect(base.perform).to be true
    end 
  
    it 'should return true nil because there is nothing to evaluate' do
      str = nil
      base = described_class.new(str, {}, 1)
      expect(base.perform).to be true
    end 
    
    it 'validates because no max number or max number not positive' do
      field_hash['max_number'] = [0, nil].sample 
      base = described_class.new('10', field_hash, 1)
      expect(base.perform).to be true
    end 

    it 'skips validation returning a true because min/max values are not present' do
      field_hash['max_number'] = nil
      field_hash['min_number'] = nil
      base = described_class.new('10', field_hash, 1)
      expect(base.perform).to be true
    end 

    it 'between min and max' do
      field_hash['max_number'] = 20
      field_hash['min_number'] = 1
      base = described_class.new('10', field_hash, 1)
      expect(base.perform).to be true
    end 

    it 'not between min and max' do
      field_hash['max_number'] = 600
      field_hash['min_number'] = 30
      base = described_class.new('10', field_hash, 1)
      expect(base.perform).to be false
    end 
  end
end 