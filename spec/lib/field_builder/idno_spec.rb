require 'rails_helper'

RSpec.describe FieldBuilder::IdnoField, type: :model do
  include RSpecHtmlMatchers

  let(:field_hash) do 
    field_hash = { "name"=>"idno", "type"=>"idno", "label"=>"Identifier", "value"=>"idno_testing", "hidden"=>"false", "disabled"=>"false", "field_id"=>"6815100000007078", "required"=>"true", "sortable"=>"true", "help_type"=>"", "read_only"=>"false", "managed_by"=>"User", "searchable"=>"true", "sort_order"=>1, "validation"=>"", "idno_format"=>"", "oai_release"=>"true", "placeholder"=>"testing placeholder", "public_release"=>"true", "display_in_list"=>"true", "start_increment"=>"1", "validation_regex"=>"", "disabled_on_insert"=>"false", "disabled_on_update"=>"false", "metadata_standards"=>[] }
  end 

  # shared examples
  context 'inherit parent behaviors without having to redo tests for all items' do
    it_behaves_like 'a field builder' 
  end

  context '.managed_by_system?' do
      it 'expects true as idno is managed by system' do 
        field_hash['managed_by'] = 'System'
        fb_idno = FieldBuilder::IdnoField.new(field_hash)
        expect(fb_idno.managed_by_system?).to eq true
      end 
      it 'expects false as idno is managed by user' do
        field_hash['managed_by'] = 'User'
        fb_idno = FieldBuilder::IdnoField.new(field_hash)
        expect(fb_idno.managed_by_system?).to eq false
      end
      it 'covers our butts and if is nil defaults to user' do
        field_hash['managed_by'] = nil
        fb_idno = FieldBuilder::IdnoField.new(field_hash)
        expect(fb_idno.managed_by_system?).to eq false
      end  
  end 

  context '.managed_by_user?' do
    it 'expects true as idno is managed by system' do 
      field_hash['managed_by'] = 'System'
      fb_idno = FieldBuilder::IdnoField.new(field_hash)
      expect(fb_idno.managed_by_user?).to eq false
    end 
    it 'expects false as idno is managed by user' do
      field_hash['managed_by'] = 'User'
      fb_idno = FieldBuilder::IdnoField.new(field_hash)
      expect(fb_idno.managed_by_user?).to eq true
    end
    it 'covers our butts and if is nil defaults to user' do
      field_hash['managed_by'] = nil
      fb_idno = FieldBuilder::IdnoField.new(field_hash)
      expect(fb_idno.managed_by_user?).to eq true
    end  
  end 

  context '.html' do 
    it 'returns an html string' do
      fb = FieldBuilder::IdnoField.new(field_hash, 'insert')
      expect(fb.html).to be_a String
    end 

    it 'expects the parent to be hidden' do
      field_hash['hidden'] = true
      fb = FieldBuilder::IdnoField.new(field_hash, 'insert')
      expect(fb.html).to be_a String
      expect(fb.html).to include 'hidden hide'
    end 

    it 'expects parent to be show' do
      field_hash['hidden'] = false
      fb = FieldBuilder::IdnoField.new(field_hash, 'insert')
      expect(fb.html).to be_a String
      expect(fb.html).to include 'show'
    end 

    it 'expects the html to contain the label' do
      fb = FieldBuilder::IdnoField.new(field_hash, 'insert')
      expect(fb.html).to be_a String
      expect(fb.html).to include fb.build_label
    end 

    it 'expects the html to contain the field id and the name' do
      field_hash['css_id'] = 'testing'
      fb = FieldBuilder::Field.new(field_hash, 'insert')
      expect(fb.html).to be_a String
      expect(fb.html).to include field_hash['css_id']
      expect(fb.html).to include field_hash['name']
    end 

    it 'expects the html to contain the other methods' do
      fb = FieldBuilder::Field.new(field_hash, 'insert')
      expect(fb.html).to be_a String
      expect(fb.html).to include fb.input_options
      expect(fb.html).to include fb.data_attributes
      expect(fb.html).to include fb.html_attributes
    end 

    it 'epects to have show or hidden and state' do
      field_hash['hidden'] = true
      fb = FieldBuilder::Field.new(field_hash, 'insert')
      expect(fb.html).to be_a String
      expect(fb.html).to include 'hidden'
      expect(fb.html).to include 'insert'
    end
  end 
end