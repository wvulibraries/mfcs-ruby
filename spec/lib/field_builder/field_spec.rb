require 'rails_helper'

RSpec.describe FieldBuilder::Field, type: :model do
  include RSpecHtmlMatchers

  let(:field_hash) do 
    field_hash = { "name"=>"idno", "type"=>"idno", "label"=>"Identifier", "value"=>"idno_testing", "hidden"=>"false", "disabled"=>"false", "field_id"=>"6815100000007078", "required"=>"true", "sortable"=>"true", "help_type"=>"", "read_only"=>"false", "managed_by"=>"User", "searchable"=>"true", "sort_order"=>1, "validation"=>"", "idno_format"=>"", "oai_release"=>"true", "placeholder"=>"testing placeholder", "public_release"=>"true", "display_in_list"=>"true", "start_increment"=>"1", "validation_regex"=>"", "disabled_on_insert"=>"false", "disabled_on_update"=>"false", "metadata_standards"=>[] }
  end 

  let(:user) {  FactoryBot.create(:user, :admin) }

  # shared examples
  context 'inherit parent behaviors without having to redo tests for all items' do
    it_behaves_like 'a field builder' 
  end
  

  context '.html' do 
    it 'returns an html string' do
      fb = FieldBuilder::Field.new(field_hash, user, 'insert')
      expect(fb.html).to be_a String
    end 

    it 'expects the parent to be hidden' do
      field_hash['hidden'] = true
      fb = FieldBuilder::Field.new(field_hash, user, 'insert')
      expect(fb.html).to be_a String
      expect(fb.html).to include 'hidden hide'
    end 

    it 'expects parent to be show' do
      field_hash['hidden'] = false
      fb = FieldBuilder::Field.new(field_hash, user, 'insert')
      expect(fb.html).to be_a String
      expect(fb.html).to include 'show'
    end 

    it 'expects the html to contain the label' do
      fb = FieldBuilder::Field.new(field_hash, user, 'insert')
      expect(fb.html).to be_a String
      expect(fb.html).to include fb.build_label
    end 
  end 
end