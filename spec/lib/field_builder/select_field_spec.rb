require 'rails_helper'

RSpec.describe FieldBuilder::SelectField, type: :model do
  include RSpecHtmlMatchers

  let(:field_hash) do 
    field_hash = {"name"=>"untitled", "type"=>"select", "label"=>"SomeDumbDropdown", "value"=>"", "css_id"=>"something_cool", "hidden"=>false, "choices"=>"another choice", "disabled"=>false, "field_id"=>"4295074064999935", "help_url"=>"", "required"=>true, "sortable"=>true, "css_class"=>"dropdown_thing", "help_info"=>"<strong> Please pick the right choice, </strong>\nor there will be trouble!", "help_type"=>"html_text", "read_only"=>false, "searchable"=>true, "sort_order"=>"5", "validation"=>"", "choice_form"=>"", "choice_type"=>"manual", "oai_release"=>true, "placeholder"=>"", "choice_array"=>"Default Choice,Another Choice,What is this,another choice", "local_styles"=>"", "no_duplicates"=>false, "default_choice"=>"Default Choice", "public_release"=>true, "display_in_list"=>false, "validation_regex"=>"", "choice_form_field"=>"", "disabled_on_insert"=>false, "disabled_on_update"=>false, "metadata_standards"=>[{"schema"=>"Dublin Core", "identifier"=>"idea", "qualifier"=>"magnets"}, {"schema"=>"Dublin Core", "identifier"=>"usage", "qualifier"=>"rightsStatement"}]}
  end 

  let(:user) {  FactoryBot.create(:user, :admin) }

  # shared examples
  context 'inherit parent behaviors without having to redo tests for all items' do
    it_behaves_like 'a field builder' 
  end

  context '.manual?' do
    it 'returns true if manual' do
      field_hash['choice_type'] = 'manual'
      fb = FieldBuilder::SelectField.new(field_hash, user)
      expect(fb.manual?).to be true
    end
    
    it 'returns true if nil or empty' do
      field_hash['choice_type'] = nil # is coerced to empty string
      fb = FieldBuilder::SelectField.new(field_hash, user)
      expect(fb.manual?).to be true
    end
    
    it 'returns false if linked to another form' do
      field_hash['choice_type'] = 'linked_to_form'
      fb = FieldBuilder::SelectField.new(field_hash, user)
      expect(fb.manual?).to be false
    end 
  end
  
  context '.linked?' do
    it 'returns true if manual' do
      field_hash['choice_type'] = 'manual'
      fb = FieldBuilder::SelectField.new(field_hash, user)
      expect(fb.linked?).to be false
    end
    
    it 'returns true if nil or empty' do
      field_hash['choice_type'] = nil # is coerced to empty string
      fb = FieldBuilder::SelectField.new(field_hash, user)
      expect(fb.linked?).to be false
    end
    
    it 'returns false if linked to another form' do
      field_hash['choice_type'] = 'link_to_form'
      fb = FieldBuilder::SelectField.new(field_hash, user)
      expect(fb.linked?).to be true
    end 
  end 

  context '.include_null_option?' do
    it 'returns true it should include a null option' do
      field_hash['choice_null'] = true
      fb = FieldBuilder::SelectField.new(field_hash, user)
      expect(fb.include_null_option?).to be true
    end

    it 'returns true it should include a null option' do
      field_hash['choice_null'] = 'true'
      fb = FieldBuilder::SelectField.new(field_hash, user)
      expect(fb.include_null_option?).to be true
    end

    it 'returns true 1 includes a null option' do
      field_hash['choice_null'] = 1 
      fb = FieldBuilder::SelectField.new(field_hash, user)
      expect(fb.include_null_option?).to be true
    end

    it 'returns true 1 includes a null option' do
      field_hash['choice_null'] = '1' 
      fb = FieldBuilder::SelectField.new(field_hash, user)
      expect(fb.include_null_option?).to be true
    end

    it 'returns true it should include a null option' do
      field_hash['choice_null'] = false
      fb = FieldBuilder::SelectField.new(field_hash, user)
      expect(fb.include_null_option?).to be false
    end

    it 'returns true it should include a null option' do
      field_hash['choice_null'] = 'false'
      fb = FieldBuilder::SelectField.new(field_hash, user)
      expect(fb.include_null_option?).to be false
    end

    it 'returns true 1 includes a null option' do
      field_hash['choice_null'] = 0
      fb = FieldBuilder::SelectField.new(field_hash, user)
      expect(fb.include_null_option?).to be false
    end

    it 'returns true 1 includes a null option' do
      field_hash['choice_null'] = nil
      fb = FieldBuilder::SelectField.new(field_hash, user)
      expect(fb.include_null_option?).to be false
    end
  end

  context '.default_option' do
    it 'should return true for the default option' do
      field_hash["default_choice"] = 'apple'
      fb = FieldBuilder::SelectField.new(field_hash, user)
      expect(fb.default_option?(field_hash["default_choice"])).to be true
    end

    it 'should return true for the default option' do
      field_hash["default_choice"] = 'apple'
      fb = FieldBuilder::SelectField.new(field_hash, user)
      expect(fb.default_option?('bananas')).to be false
    end
  end
  

  context '.options' do
    it 'should contain a null option' do
      field_hash['choice_null'] = true
      fb = FieldBuilder::SelectField.new(field_hash, user)
      expect(fb.options).to include('<option value=""> Select an Option </option>')
    end

    it 'should contain a null option' do
      field_hash['choice_null'] = nil
      fb = FieldBuilder::SelectField.new(field_hash, user)
      expect(fb.options).to_not include('<option value=""> Select an Option </option>')
    end
  end

  context '.manual_options' do
    it 'should return a string' do
      field_hash['choice_type'] = "manual"
      field_hash['choice_array'] = "Default Choice,Another Choice,What is this,another choice"
      fb = FieldBuilder::SelectField.new(field_hash, user)
      expect(fb.manual_options).to be_a String
    end

    it 'should return the option as a formatted option' do
      field_hash['choice_type'] = "manual"
      field_hash['choice_array'] = "Default Choice,Another Choice,What is this, another choice"
      fb = FieldBuilder::SelectField.new(field_hash, user)
      expect(fb.manual_options).to include('option', 'Default Choice', 'Another Choice', 'What is this', 'another choice')
    end
  end

  context '.html' do
    it 'expects html string' do
      fb = FieldBuilder::SelectField.new(field_hash, user, 'insert')
      expect(fb.html).to be_a String
    end 
    
    it 'expects the html to contain the label' do
      fb = FieldBuilder::SelectField.new(field_hash, user, 'insert')
      expect(fb.html).to include fb.build_label
    end
    
    it 'should contain help html' do
      fb = FieldBuilder::SelectField.new(field_hash, user, 'insert')
      expect(fb.html).to include fb.help_html
    end 

    it 'should contain the name, css_class, and css_id' do
      fb = FieldBuilder::SelectField.new(field_hash, user, 'insert')
      expect(fb.html).to include(field_hash['css_class'])
      expect(fb.html).to include(field_hash['css_id'])
      expect(fb.html).to include(field_hash['name'])
    end
    

    it 'should contain the default value' do
      fb = FieldBuilder::SelectField.new(field_hash, user, 'insert')
      expect(fb.html).to include(fb.data_attributes)
    end
  end 
end