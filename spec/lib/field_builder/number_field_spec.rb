require 'rails_helper'

RSpec.describe FieldBuilder::NumberField, type: :model do
  include RSpecHtmlMatchers

  let(:field_hash) do 
    field_hash ={"name"=>"UntitledNumberField", "step"=>"1", "type"=>"number", "label"=>"Untitled Number Field", "value"=>"", "css_id"=>"", "hidden"=>false, "disabled"=>false, "field_id"=>"1785759999998845", "help_url"=>"", "required"=>false, "sortable"=>false, "css_class"=>"", "help_info"=>"Some number between 1 and 100", "help_type"=>"plain_text", "read_only"=>false, "max_number"=>"100", "min_number"=>"1", "searchable"=>false, "sort_order"=>"2.1", "validation"=>"integer", "oai_release"=>false, "placeholder"=>"1", "local_styles"=>"", "no_duplicates"=>false, "public_release"=>true, "display_in_list"=>false, "validation_regex"=>"", "disabled_on_insert"=>false, "disabled_on_update"=>false, "metadata_standards"=>[{"schema"=>"Dublin Core", "identifier"=>"number", "qualifier"=>"itemCount"}]}
  end 

  let(:user) {  FactoryBot.create(:user, :admin) }

  # shared examples
  context 'inherit parent behaviors without having to redo tests for all items' do
    it_behaves_like 'a field builder' 
  end

  context '.number_attributes' do
    it 'should contain a min/max data attribute' do
      field_hash['min_number'] = 5
      field_hash['max_number'] = 130
      field_hash['step'] = 5 
      fb = FieldBuilder::NumberField.new(field_hash, user)
      expect(fb.number_attributes).to include("#{field_hash['min_number']}")
      expect(fb.number_attributes).to include("#{field_hash['max_number']}")
      expect(fb.number_attributes).to include("#{field_hash['step']}")
    end
  end

  context '.html' do
    it 'expects html string' do
      fb = FieldBuilder::NumberField.new(field_hash, user, 'insert')
      expect(fb.html).to be_a String
    end 
    
    it 'expects the html to contain the label' do
      fb = FieldBuilder::NumberField.new(field_hash, user, 'insert')
      expect(fb.html).to include fb.build_label
    end
    
    it 'should contain an input type text' do
      fb = FieldBuilder::NumberField.new(field_hash, user, 'insert')
      expect(fb.html).to include 'number'
    end
    
    it 'should contain help html' do
      fb = FieldBuilder::NumberField.new(field_hash, user, 'insert')
      expect(fb.html).to include fb.help_html
    end 

    it 'should contain data attributes' do
      fb = FieldBuilder::NumberField.new(field_hash, user, 'insert')
      expect(fb.html).to include fb.data_attributes
    end 

    it 'should contain the name, css_class, and css_id' do
      fb = FieldBuilder::NumberField.new(field_hash, user, 'insert')
      expect(fb.html).to include (field_hash['css_class'])
      expect(fb.html).to include (field_hash['css_id'])
      expect(fb.html).to include (field_hash['name'])
    end
  end 
end