require 'rails_helper'

RSpec.describe Validator::TextLength, type: :model do
  let(:form) { FactoryBot.create(:form) }
  let(:field_hash) do 
    field_hash = [{"max"=>"", "min"=>"", "name"=>"title", "step"=>"", "type"=>"text", "label"=>"AcquisitionTitle", "value"=>"", "css_id"=>"title", "format"=>"characters", "hidden"=>"", "disabled"=>"false", "field_id"=>"0", "help_url"=>"", "readonly"=>"false", "required"=>"true", "sortable"=>"", "css_class"=>"", "help_info"=>"", "help_type"=>"no_help", "searchable"=>"", "sort_order"=>"0", "validation"=>"", "placeholder"=>"", "local_styles"=>"width:90%;", "no_duplicates"=>"true", "public_release"=>"true", "display_in_list"=>"", "validation_regex"=>"", "disabled_on_insert"=>"false", "disabled_on_update"=>"false", "metadata_standards"=>[]}]
  end 

  context 'instance variables' do
    before(:each) do
      form.fields = field_hash 
      form.save!
    end
  end 
  
  context '.perform' do
    before(:each) do
      form.fields = field_hash 
      form.save!
    end
  end 
  
  context '.divisible_by_step?' do 
    it 'returns valid or true because the step is 0' do
      expect(Validator.divisible_by_step?(15,0)).to be true
    end 
    
    it 'step is a multiple of the number' do
      expect(Validator.divisible_by_step?(9,3)).to be true
    end

    it 'step is not a multiple of the number' do
      expect(Validator.divisible_by_step?(9,5)).to be false
    end
  end 

  context '.between_min_max?' do
    it 'validates because no max number or max number not positive' do
      max = [nil, 0]
      expect(Validator.between_min_max?(10, 1, max.sample)).to be true
    end 

    it 'skips validation returning a true because min/max values are not present' do
      expect(Validator.between_min_max?(100, nil, nil)).to be true
    end 

    it 'between min and max' do
      expect(Validator.between_min_max?(10, 1, 20)).to be true
    end 

    it 'not between min and max' do
      expect(Validator.between_min_max?(8, 15, 20)).to be false
    end 
  end 
end 