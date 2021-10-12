
RSpec.shared_examples "a choice field" do
  include RSpecHtmlMatchers

  let(:field_hash) do 
    field_hash = {"name"=>"dropdown", "type"=>"select", "label"=>"A dropdown menu", "value"=>"", "css_id"=>"", "hidden"=>false, "choices"=>"Awesome", "disabled"=>false, "field_id"=>"10518135000020266", "help_url"=>"", "required"=>false, "sortable"=>false, "css_class"=>"", "help_info"=>"", "help_type"=>"", "read_only"=>false, "searchable"=>false, "sort_order"=>"4", "validation"=>"", "choice_form"=>"", "choice_null"=>true, "choice_type"=>"manual", "oai_release"=>false, "placeholder"=>"", "choice_array"=>"Testing,Something Really Cool,Awesome", "local_styles"=>"", "no_duplicates"=>false, "default_choice"=>"", "public_release"=>true, "display_in_list"=>false, "validation_regex"=>"", "choice_form_field"=>"", "disabled_on_insert"=>false, "disabled_on_update"=>false, "metadata_standards"=>[{"schema"=>"Dublin Core", "identifier"=>"idea", "qualifier"=>"magnets"}, {"schema"=>"Dublin Core", "identifier"=>"usage", "qualifier"=>"rightsStatement"}]}
  end 

  let(:user) {  FactoryBot.create(:user, :admin) }

  context '.manual?' do
    it 'returns true if manual' do
      field_hash['choice_type'] = 'manual'
      fb = described_class.new(field_hash, user)
      expect(fb.manual?).to be true
    end
    
    it 'returns true if nil or empty' do
      field_hash['choice_type'] = nil # is coerced to empty string
      fb = described_class.new(field_hash, user)
      expect(fb.manual?).to be true
    end
    
    it 'returns false if linked to another form' do
      field_hash['choice_type'] = 'linked_to_form'
      fb = described_class.new(field_hash, user)
      expect(fb.manual?).to be false
    end 
  end

  context '.linked?' do
    it 'returns true if manual' do
      field_hash['choice_type'] = 'manual'
      fb = described_class.new(field_hash, user)
      expect(fb.linked?).to be false
    end
    
    it 'returns true if nil or empty' do
      field_hash['choice_type'] = nil # is coerced to empty string
      fb = described_class.new(field_hash, user)
      expect(fb.linked?).to be false
    end
    
    it 'returns false if linked to another form' do
      field_hash['choice_type'] = 'link_to_form'
      fb = described_class.new(field_hash, user)
      expect(fb.linked?).to be true
    end 
  end 

  context '.include_null_option?' do
    it 'returns true it should include a null option' do
      field_hash['choice_null'] = true
      fb = described_class.new(field_hash, user)
      expect(fb.include_null_option?).to be true
    end

    it 'returns true it should include a null option' do
      field_hash['choice_null'] = 'true'
      fb = described_class.new(field_hash, user)
      expect(fb.include_null_option?).to be true
    end

    it 'returns true 1 includes a null option' do
      field_hash['choice_null'] = 1 
      fb = described_class.new(field_hash, user)
      expect(fb.include_null_option?).to be true
    end

    it 'returns true 1 includes a null option' do
      field_hash['choice_null'] = '1' 
      fb = described_class.new(field_hash, user)
      expect(fb.include_null_option?).to be true
    end

    it 'returns true it should include a null option' do
      field_hash['choice_null'] = false
      fb = described_class.new(field_hash, user)
      expect(fb.include_null_option?).to be false
    end

    it 'returns true it should include a null option' do
      field_hash['choice_null'] = 'false'
      fb = described_class.new(field_hash, user)
      expect(fb.include_null_option?).to be false
    end

    it 'returns true 1 includes a null option' do
      field_hash['choice_null'] = 0
      fb = described_class.new(field_hash, user)
      expect(fb.include_null_option?).to be false
    end

    it 'returns true 1 includes a null option' do
      field_hash['choice_null'] = nil
      fb = described_class.new(field_hash, user)
      expect(fb.include_null_option?).to be false
    end
  end

  context '.default_option' do
    it 'should return true for the default option' do
      field_hash["default_choice"] = 'apple'
      fb = described_class.new(field_hash, user)
      expect(fb.default_option?(field_hash["default_choice"])).to be true
    end

    it 'should return true for the default option' do
      field_hash["default_choice"] = 'apple'
      fb = described_class.new(field_hash, user)
      expect(fb.default_option?('bananas')).to be false
    end
  end


  context '.options' do
    it 'should contain a null option' do
      field_hash['choice_null'] = true
      fb = described_class.new(field_hash, user)
      expect(fb.options).to include('<option value=""> Select an Option </option>')
    end

    it 'should contain a null option' do
      field_hash['choice_null'] = nil
      fb = described_class.new(field_hash, user)
      expect(fb.options).to_not include('<option value=""> Select an Option </option>')
    end
  end

  context '.manual_options' do
    it 'should return a string' do
      field_hash['choice_type'] = "manual"
      field_hash['choice_array'] = "Default Choice,Another Choice,What is this,another choice"
      fb = described_class.new(field_hash, user)
      expect(fb.manual_options).to be_a String
    end

    it 'should return the option as a formatted option' do
      field_hash['choice_type'] = "manual"
      field_hash['choice_array'] = "Default Choice,Another Choice,What is this, another choice"
      fb = described_class.new(field_hash, user)
      expect(fb.manual_options).to include('option', 'Default Choice', 'Another Choice', 'What is this', 'another choice')
    end
  end

  context '.linked_options' do
    # it 'should be a string' do
    #   form = FactoryBot.create(:form)
    #   names = (1..10).map { Faker::Movies::LordOfTheRings.character }.uniq.sort
      
    #   names.each do |title|  
    #     item = FactoryBot.build(:metadata)
    #     item.data = {"dropdown" => "#{title}"}
    #     item.form_id = form.id
    #     item.save! 
    #   end 

    #   field_hash['choice_type'] = "link_to_form"
    #   field_hash['choice_form'] = form.id.to_s
    #   field_hash['choice_array'] = nil
    #   field_hash['choice_form_field'] = 'dropdown'

    #   fb = described_class.new(field_hash, user)
    #   expect(fb.linked_options).to be_a String
    # end
    
    # it 'should have items from the correct form' do
    #   form = FactoryBot.create(:form)
    #   names = (1..10).map { Faker::Movies::LordOfTheRings.character }.uniq.sort
      
    #   names.each do |title|  
    #     item = FactoryBot.build(:metadata)
    #     item.data = {"dropdown" => "#{title}"}
    #     item.form_id = form.id
    #     item.save! 
    #   end 

    #   field_hash['choice_type'] = "link_to_form"
    #   field_hash['choice_form'] = form.id.to_s
    #   field_hash['choice_array'] = nil
    #   field_hash['choice_form_field'] = 'dropdown'

    #   fb = described_class.new(field_hash, user)
    #   names.each do |name| 
    #     expect(fb.linked_options).to include(name)
    #   end
    # end
    
    it 'should be empty there are no items' do
      form = FactoryBot.create(:form)
      field_hash['choice_type'] = "link_to_form"
      field_hash['choice_form'] = form.id.to_s
      field_hash['choice_array'] = nil
      field_hash['choice_form_field'] = 'dropdown'

      fb = described_class.new(field_hash, user)
      expect(fb.linked_options).to eq ''
    end 
  end 

  context '.html' do
    it 'expects html string' do
      fb = described_class.new(field_hash, user, 'insert')
      expect(fb.html).to be_a String
    end 
    
    it 'expects the html to contain the label' do
      fb = described_class.new(field_hash, user, 'insert')
      expect(fb.html).to include fb.build_label
    end
    
    it 'should contain help html' do
      fb = described_class.new(field_hash, user, 'insert')
      expect(fb.html).to include fb.help_html
    end 

    it 'should contain the name, css_class, and css_id' do
      fb = described_class.new(field_hash, user, 'insert')
      expect(fb.html).to include(field_hash['css_class'])
      expect(fb.html).to include(field_hash['css_id'])
      expect(fb.html).to include(field_hash['name'])
    end
    
    it 'should contain the default value' do
      fb = described_class.new(field_hash, user, 'insert')
      expect(fb.html).to include(fb.data_attributes)
    end
  end 
end