require 'rails_helper'

RSpec.describe FieldBuilder::TextField, type: :model do
  include RSpecHtmlMatchers

  let(:field_hash) do 
    field_hash = { "name"=>"idno", "type"=>"text", "label"=>"Text Field", "value"=>"testing %date%", "hidden"=>"false", "disabled"=>"false", "field_id"=>"6815100000007078", "required"=>"true", "sortable"=>"true", "help_type"=>"", "read_only"=>"false", "managed_by"=>"User", "searchable"=>"true", "sort_order"=>1, "validation"=>"", "idno_format"=>"", "oai_release"=>"true", "placeholder"=>"testing placeholder", "public_release"=>"true", "display_in_list"=>"true", "start_increment"=>"1", "validation_regex"=>"", "disabled_on_insert"=>"false", "disabled_on_update"=>"false", "metadata_standards"=>[] }
  end 

  # shared examples
  context 'inherit parent behaviors without having to redo tests for all items' do
    it_behaves_like 'a field builder' 
  end

  context '.default_value?' do
    it 'should have a value and default to true' do
      field_hash['value'] = "something darkside"
      fb = FieldBuilder::TextField.new(field_hash)
      expect(fb.default_value?).to be_in([true, false])
      expect(fb.default_value?).to be true  
    end
  end 
end