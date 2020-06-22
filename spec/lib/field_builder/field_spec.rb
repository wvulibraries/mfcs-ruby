require 'rails_helper'

RSpec.describe FieldBuilder::Field, type: :model do
  include RSpecHtmlMatchers

  let(:field_hash) do 
    field_hash = { "name"=>"idno", "type"=>"idno", "label"=>"Identifier", "value"=>"idno_testing", "hidden"=>"false", "disabled"=>"false", "field_id"=>"6815100000007078", "required"=>"true", "sortable"=>"true", "help_type"=>"", "read_only"=>"false", "managed_by"=>"User", "searchable"=>"true", "sort_order"=>1, "validation"=>"", "idno_format"=>"", "oai_release"=>"true", "placeholder"=>"testing placeholder", "public_release"=>"true", "display_in_list"=>"true", "start_increment"=>"1", "validation_regex"=>"", "disabled_on_insert"=>"false", "disabled_on_update"=>"false", "metadata_standards"=>[] }
  end 

  context '.init' do 
    it 'should not initialize without a valid field hash' do
      expect { FieldBuilder::Field.new('testing 124', 'update') }.to raise_error(ArgumentError)
    end 

    it 'should init using a valid hash' do
      fb = FieldBuilder::Field.new(field_hash, 'insert')
      expect(fb).to be_an_instance_of FieldBuilder::Field 
    end
    
    it 'should be valid without a second parameter' do
      fb = FieldBuilder::Field.new(field_hash)
      expect(fb).to be_an_instance_of FieldBuilder::Field 
    end 
  end  

  context '.disabled?' do
    it 'should return a boolean no matter what' do
      fb = FieldBuilder::Field.new(field_hash)
      expect(fb.disabled?).to be_in([true, false])
    end 

    it 'result should be false for the disabled on insert' do
      field_hash['disabled'] = false
      field_hash['disabled_on_insert'] = false
      field_hash['disabled_on_update'] = false
      fb = FieldBuilder::Field.new(field_hash)
      expect(fb.disabled?).to be false
    end 

    it 'result should be true for the disabled on insert' do
      field_hash['disabled'] = false
      field_hash['disabled_on_insert'] = true
      field_hash['disabled_on_update'] = false
      fb = FieldBuilder::Field.new(field_hash)
      expect(fb.disabled?).to be true
    end 

    it 'result should be true disabled set' do
      field_hash['disabled'] = true
      field_hash['disabled_on_insert'] = false
      field_hash['disabled_on_update'] = false
      fb = FieldBuilder::Field.new(field_hash)
      expect(fb.disabled?).to be true
    end 

    it 'result should be false for the disabled on update' do
      field_hash['disabled'] = false
      field_hash['disabled_on_insert'] = false
      field_hash['disabled_on_update'] = false
      fb = FieldBuilder::Field.new(field_hash, 'update')
      expect(fb.disabled?).to be false
    end 

    it 'result should be true for the disabled on update' do
      field_hash['disabled'] = false
      field_hash['disabled_on_insert'] = false
      field_hash['disabled_on_update'] = true
      fb = FieldBuilder::Field.new(field_hash, 'update')
      expect(fb.disabled?).to be true
    end 

    it 'result should be true for the disabled on update because main flag is true' do
      field_hash['disabled'] = true
      field_hash['disabled_on_insert'] = false
      field_hash['disabled_on_update'] = false
      fb = FieldBuilder::Field.new(field_hash, 'update')
      expect(fb.disabled?).to be true
    end 

    it 'should be true if state is disabled' do
      field_hash['disabled'] = false
      field_hash['disabled_on_insert'] = false
      field_hash['disabled_on_update'] = false
      fb = FieldBuilder::Field.new(field_hash, 'disabled')
      expect(fb.disabled?).to be true
    end 

    it 'should be true if state is preview' do
      field_hash['disabled'] = false
      field_hash['disabled_on_insert'] = false
      field_hash['disabled_on_update'] = false
      fb = FieldBuilder::Field.new(field_hash, 'preview')
      expect(fb.disabled?).to be true
    end 

    it 'should default to the disabled value if state is unknown (false)' do
      field_hash['disabled'] = false
      fb = FieldBuilder::Field.new(field_hash, 'something')
      expect(fb.disabled?).to be false
    end 

    it 'should default to the disabled value if state is unknown (true)' do
      field_hash['disabled'] = true
      fb = FieldBuilder::Field.new(field_hash, 'something')
      expect(fb.disabled?).to be true
    end 
  end 

  context '.help_html' do
    it 'should return an html string as a link' do 
      field_hash['help_type'] = 3
      fb = FieldBuilder::Field.new(field_hash, 'insert')
      expect(fb.help_html).to be_a String
      expect(fb.help_html).to have_tag('a')
    end 

    it 'should return an html string as a span' do 
      field_hash['help_type'] = 2
      fb = FieldBuilder::Field.new(field_hash, 'insert')
      expect(fb.help_html).to be_a String
      expect(fb.help_html).to have_tag('span')
    end 

    it 'should return an html string as a span' do 
      field_hash['help_type'] = 1
      fb = FieldBuilder::Field.new(field_hash, 'insert')
      expect(fb.help_html).to be_a String
      expect(fb.help_html).to have_tag('span')
    end 

    it 'should return nil as the html help does not exist' do 
      field_hash['help_type'] = 0
      fb = FieldBuilder::Field.new(field_hash, 'insert')
      expect(fb.help_html).to be nil
    end 
  end 

  context '.input_options' do
    it 'should respond with a string formatted for use in HTML' do
      fb = FieldBuilder::Field.new(field_hash, 'insert')
      expect(fb.input_options).to be_a String
      expect(fb.input_options).to include('name', 'label', 'value', 'placeholder', 'read_only', 'required', 'hidden') 
    end 

    it 'should not include name' do
      field_hash['name'] = ''
      fb = FieldBuilder::Field.new(field_hash, 'insert')
      expect(fb.input_options).to be_a String
      expect(fb.input_options).to include('label', 'value', 'placeholder', 'read_only', 'required', 'hidden') 
      expect(fb.input_options).not_to include('name') 
    end 
  end
  
  context '.data_attributes' do
    it 'expects validation and validation regex by default as data attributes' do
      field_hash['validation'] = 'regex'
      field_hash['validation_regex'] = %r{(^\d*\.?\d*[1-9]+\d*$)|(^[1-9]+\d*\.\d*$)}
      fb = FieldBuilder::Field.new(field_hash, 'insert')
      expect(fb.data_attributes).to be_a String
      expect(fb.data_attributes).to include('data-validation', 'data-validation_regex') 
    end 

    it 'does not have any validations and data attributes because none of them have value' do
      field_hash['validation'] = ''
      field_hash['validation_regex'] = ''
      fb = FieldBuilder::Field.new(field_hash, 'insert')
      expect(fb.data_attributes).to be_a String
      expect(fb.data_attributes).not_to include('data-validation', 'data-validation_regex') 
    end 
  end 

  context '.html' do
    it 'expects to get an html string' do
      fb = FieldBuilder::Field.new(field_hash, 'insert')
      puts fb.html
      expect(fb.html).to be_a String
    end 
  end 
end