RSpec.shared_examples "a field builder" do
  include RSpecHtmlMatchers

  let(:field_hash) do 
    field_hash = { "name"=>"idno", "type"=>"idno", "label"=>"Identifier", "value"=>"idno_testing", "hidden"=>"false", "disabled"=>"false", "field_id"=>"6815100000007078", "required"=>"true", "sortable"=>"true", "help_type"=>"", "read_only"=>"false", "managed_by"=>"User", "searchable"=>"true", "sort_order"=>1, "validation"=>"", "idno_format"=>"", "oai_release"=>"true", "placeholder"=>"testing placeholder", "public_release"=>"true", "display_in_list"=>"true", "start_increment"=>"1", "validation_regex"=>"", "disabled_on_insert"=>"false", "disabled_on_update"=>"false", "metadata_standards"=>[] }
  end 
  
  let(:user) {  FactoryBot.create(:user, :admin) }


  context '.init' do 
    it 'should not initialize without a valid field hash' do
      expect { described_class.new('testing 124', 'update') }.to raise_error(ArgumentError)
    end 

    it 'should init using a valid hash' do
      fb = described_class.new(field_hash, user, 'insert')
      expect(fb).to be_an_instance_of described_class
    end
    
    it 'should be valid without a second parameter' do
      fb = described_class.new(field_hash, user)
      expect(fb).to be_an_instance_of described_class
    end 
  end  

  context '.disabled?' do
    it 'should return a boolean no matter what' do
      fb = described_class.new(field_hash, user)
      expect(fb.disabled?).to be_in([true, false])
    end 

    it 'result should be false for the disabled on insert' do
      field_hash['disabled'] = false
      field_hash['disabled_on_insert'] = false
      field_hash['disabled_on_update'] = false
      fb = described_class.new(field_hash, user, 'create')
      expect(fb.disabled?).to be false
    end 

    it 'result should be true for the disabled on insert' do
      field_hash['disabled'] = false
      field_hash['disabled_on_insert'] = true
      field_hash['disabled_on_update'] = false
      fb = described_class.new(field_hash, user, 'create')
      expect(fb.disabled?).to be true
    end 

    it 'result should be true disabled set' do
      field_hash['disabled'] = true
      field_hash['disabled_on_insert'] = false
      field_hash['disabled_on_update'] = false
      fb = described_class.new(field_hash, user, 'create')
      expect(fb.disabled?).to be true
    end 

    it 'result should be false for the disabled on update' do
      field_hash['disabled'] = false
      field_hash['disabled_on_insert'] = false
      field_hash['disabled_on_update'] = false
      fb = described_class.new(field_hash, user, 'update')
      expect(fb.disabled?).to be false
    end 

    it 'result should be true for the disabled on update' do
      field_hash['disabled'] = false
      field_hash['disabled_on_insert'] = false
      field_hash['disabled_on_update'] = true
      fb = described_class.new(field_hash, user, 'update')
      expect(fb.disabled?).to be true
    end 

    it 'result should be true for the disabled on update because main flag is true' do
      field_hash['disabled'] = true
      field_hash['disabled_on_insert'] = false
      field_hash['disabled_on_update'] = false
      fb = described_class.new(field_hash, user, 'update')
      expect(fb.disabled?).to be true
    end 

    it 'should be true if state is disabled' do
      field_hash['disabled'] = false
      field_hash['disabled_on_insert'] = false
      field_hash['disabled_on_update'] = false
      fb = described_class.new(field_hash, user, 'disabled')
      expect(fb.disabled?).to be true
    end 

    it 'should be true if state is preview' do
      field_hash['disabled'] = false
      field_hash['disabled_on_insert'] = false
      field_hash['disabled_on_update'] = false
      fb = described_class.new(field_hash, user, 'preview')
      expect(fb.disabled?).to be true
    end 

    it 'should default to the disabled value if state is unknown (false)' do
      field_hash['disabled'] = false
      fb = described_class.new(field_hash, user, 'something')
      expect(fb.disabled?).to be false
    end 

    it 'should default to the disabled value if state is unknown (true)' do
      field_hash['disabled'] = true
      fb = described_class.new(field_hash, user, 'something')
      expect(fb.disabled?).to be true
    end 
  end 

  context '.help_html' do
    it 'should return an html string as a link' do 
      field_hash['help_type'] = 'help_url'
      fb = described_class.new(field_hash, user, 'insert')
      expect(fb.help_html).to be_a String
      expect(fb.help_html).to have_tag('a')
    end 

    it 'should return an html string as a span' do 
      field_hash['help_type'] = 'html_text'
      fb = described_class.new(field_hash, user, 'insert')
      expect(fb.help_html).to be_a String
      expect(fb.help_html).to have_tag('span')
    end 

    it 'should return an html string as a span' do 
      field_hash['help_type'] = 'plain_text'
      fb = described_class.new(field_hash, user, 'insert')
      expect(fb.help_html).to be_a String
      expect(fb.help_html).to have_tag('span')
    end 

    it 'should return nil as the html help does not exist' do 
      field_hash['help_type'] = 'no_help'
      fb = described_class.new(field_hash, user, 'insert')
      expect(fb.help_html).to eq ''
    end 
  end 

  context '.readonly?' do
    it 'should return true because field info says it is readonly' do
      field_hash['read_only'] = true 
      fb = described_class.new(field_hash, user, 'insert')
      expect(fb.readonly?).to be_in([true,false])
      expect(fb.readonly?).to be true 
    end 

    it 'string values should return as well as bool values (true)' do
      field_hash['read_only'] = 'true'
      fb = described_class.new(field_hash, user, 'insert')
      expect(fb.readonly?).to be_in([true,false])
      expect(fb.readonly?).to be true 
    end 

    it 'string values should return as well as bool values (false)' do
      field_hash['read_only'] = 'false'
      fb = described_class.new(field_hash, user, 'insert')
      expect(fb.readonly?).to be_in([true,false])
      expect(fb.readonly?).to be false
    end 

    it 'should return false because field info says it is not readonly' do
      field_hash['read_only'] = false
      fb = described_class.new(field_hash, user, 'insert')
      expect(fb.readonly?).to be_in([true,false])
      expect(fb.readonly?).to be false 
    end 

    it 'should return false because item was left nil' do
      field_hash['read_only'] = nil
      fb = described_class.new(field_hash, user, 'insert')
      expect(fb.readonly?).to be_in([true,false])
      expect(fb.readonly?).to be false
    end 
  end 

  context '.required?' do
    it 'should return true because field info says it is required' do
      field_hash['required'] = true 
      fb = described_class.new(field_hash, user, 'insert')
      expect(fb.required?).to be_in([true,false])
      expect(fb.required?).to be true 
    end 

    it 'string values should return as well as bool values (true)' do
      field_hash['required'] = 'true'
      fb = described_class.new(field_hash, user, 'insert')
      expect(fb.required?).to be_in([true,false])
      expect(fb.required?).to be true 
    end 

    it 'string values should return as well as bool values (false)' do
      field_hash['required'] = 'false'
      fb = described_class.new(field_hash, user, 'insert')
      expect(fb.required?).to be_in([true,false])
      expect(fb.required?).to be false
    end 

    it 'should return false because field info says it is not required' do
      field_hash['required'] = false
      fb = described_class.new(field_hash, user, 'insert')
      expect(fb.required?).to be_in([true,false])
      expect(fb.required?).to be false 
    end 

    it 'should return false because item was left nil' do
      field_hash['required'] = nil
      fb = described_class.new(field_hash, user, 'insert')
      expect(fb.required?).to be_in([true,false])
      expect(fb.required?).to be false
    end 
  end 


  context '.hidden?' do
    it 'should return true because field info says it is hidden' do
      field_hash['hidden'] = true 
      fb = described_class.new(field_hash, user, 'insert')
      expect(fb.hidden?).to be_in([true,false])
      expect(fb.hidden?).to be true 
    end 

    it 'string values should return as well as bool values (true)' do
      field_hash['hidden'] = 'true'
      fb = described_class.new(field_hash, user, 'insert')
      expect(fb.hidden?).to be_in([true,false])
      expect(fb.hidden?).to be true 
    end 

    it 'string values should return as well as bool values (false)' do
      field_hash['hidden'] = 'false'
      fb = described_class.new(field_hash, user, 'insert')
      expect(fb.hidden?).to be_in([true,false])
      expect(fb.hidden?).to be false
    end 

    it 'should return false because field info says it is not hidden' do
      field_hash['hidden'] = false
      fb = described_class.new(field_hash, user, 'insert')
      expect(fb.hidden?).to be_in([true,false])
      expect(fb.hidden?).to be false 
    end 

    it 'should return false because item was left nil' do
      field_hash['hidden'] = nil
      fb = described_class.new(field_hash, user, 'insert')
      expect(fb.hidden?).to be_in([true,false])
      expect(fb.hidden?).to be false
    end 
  end 

  context '.input_options' do
    it 'should respond with a string formatted for use in HTML' do
      fb = described_class.new(field_hash, user, 'insert')
      expect(fb.input_options).to be_a String
      expect(fb.input_options).to include('name', 'label', 'placeholder') 
    end 

    it 'should not include name' do
      field_hash['name'] = ''
      fb = described_class.new(field_hash, user, 'insert')
      expect(fb.input_options).to be_a String
      expect(fb.input_options).to include('label', 'placeholder') 
      expect(fb.input_options).not_to include('name') 
    end 
  end
  
  context '.data_attributes' do
    it 'expects validation and validation regex by default as data attributes' do
      field_hash['validation'] = 'regex'
      field_hash['validation_regex'] = %r{(^\d*\.?\d*[1-9]+\d*$)|(^[1-9]+\d*\.\d*$)}
      fb = described_class.new(field_hash, user, 'insert')
      expect(fb.data_attributes).to be_a String
      expect(fb.data_attributes).to include('data-validation', 'data-validation_regex') 
    end 

    it 'does not have any validations and data attributes because none of them have value' do
      field_hash['validation'] = ''
      field_hash['validation_regex'] = ''
      fb = described_class.new(field_hash, user, 'insert')
      expect(fb.data_attributes).to be_a String
      expect(fb.data_attributes).not_to include('data-validation', 'data-validation_regex') 
    end 
  end 

  # context '.html' do 
  #   it 'returns an html string' do
  #     fb = described_class.new(field_hash, user, 'insert')
  #     expect(fb.html).to be_a String
  #   end 
  # end 

  context '.build_label' do
    it 'returns an html string from the label' do
      field_hash['required'] = true 
      expected_string = <<-HTML
        <label for="#{field_hash['name']}" class="required"> #{field_hash['label']} </label>
      HTML
      fb = described_class.new(field_hash, user, 'insert')
      expect(fb.build_label).to be_a String
      expect(fb.build_label).to eq expected_string
    end 

    it 'returns an html string from the label with no class required' do
      field_hash['required'] = false
      expected_string = <<-HTML
        <label for="#{field_hash['name']}" class=""> #{field_hash['label']} </label>
      HTML
      fb = described_class.new(field_hash, user, 'insert')
      expect(fb.build_label).to be_a String
      expect(fb.build_label).to eq expected_string
    end 
  end 

  context '.css_classes' do
    it 'has the classes from the css_classes item and the field_id' do
      field_hash['field_id'] = 12123
      field_hash['css_class'] = 'something darkside and cool'
      field_hash['readonly'] = false
      field_hash['required'] = false
      field_hash['disabled'] = false
      field_hash['disabled_on_insert'] = false
      field_hash['disabled_on_update'] = false
      fb = described_class.new(field_hash, user, 'insert')
      expect(fb.css_classes).to be_a String
      expect(fb.css_classes).to include field_hash['css_class']
      expect(fb.css_classes).to include field_hash['field_id'].to_s
      expect(fb.css_classes).to_not include 'disabled'
      expect(fb.css_classes).to_not include 'readonly'
      expect(fb.css_classes).to_not include 'required'
    end 

    it 'has the classes from the css_classes item and the field_id' do
      field_hash['field_id'] = 12123
      field_hash['css_class'] = 'something darkside and cool'
      field_hash['read_only'] = true
      field_hash['required'] = true
      field_hash['disabled'] = true
      fb = described_class.new(field_hash, user, 'insert')
      expect(fb.css_classes).to be_a String
      expect(fb.css_classes).to include field_hash['css_class']
      expect(fb.css_classes).to include field_hash['field_id'].to_s
      expect(fb.css_classes).to include 'disabled'
      expect(fb.css_classes).to include 'readonly'
      expect(fb.css_classes).to include 'required'
    end 
  end 

  context '.html_attributes' do
    it 'returns a string that reads readonly, disabled, and required' do
      field_hash['disabled'] = true
      field_hash['disabled_on_insert'] = true
      field_hash['read_only'] = true
      field_hash['required'] = true
      fb = described_class.new(field_hash, user, 'insert')
      expect(fb.html_attributes).to be_a String
      expect(fb.html_attributes).to eq 'readonly disabled required'
    end 

    it 'returns a string that is empty' do
      field_hash['disabled'] = false
      field_hash['read_only'] = false
      field_hash['required'] = false
      fb = described_class.new(field_hash, user, 'insert')
      expect(fb.html_attributes).to be_a String
      expect(fb.html_attributes).to eq ''
    end 

    it 'returns a string that is readonly' do
      field_hash['disabled'] = false
      field_hash['read_only'] = true
      field_hash['required'] = false
      fb = described_class.new(field_hash, user, 'insert')
      expect(fb.html_attributes).to be_a String
      expect(fb.html_attributes).to eq 'readonly'
    end

    it 'returns a string that is required' do
      field_hash['disabled'] = false
      field_hash['read_only'] = false
      field_hash['required'] = true
      fb = described_class.new(field_hash, user, 'insert')
      expect(fb.html_attributes).to be_a String
      expect(fb.html_attributes).to eq 'required'
    end 

    it 'returns a string that is disabled' do
      field_hash['disabled'] = true
      field_hash['read_only'] = false
      field_hash['required'] = false
      fb = described_class.new(field_hash, user, 'insert')
      expect(fb.html_attributes).to be_a String
      expect(fb.html_attributes).to eq 'disabled'
    end 
  end
 end