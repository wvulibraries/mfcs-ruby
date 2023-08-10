require 'rails_helper'

RSpec.describe FieldBuilder::SelectField, type: :model do
  include RSpecHtmlMatchers

  let(:field_hash) do 
    field_hash = {"name"=>"dropdown", "type"=>"select", "label"=>"A dropdown menu", "value"=>"", "css_id"=>"", "hidden"=>false, "choices"=>"Awesome", "disabled"=>false, "field_id"=>"10518135000020266", "help_url"=>"", "required"=>false, "sortable"=>false, "css_class"=>"", "help_info"=>"", "help_type"=>"", "read_only"=>false, "searchable"=>false, "sort_order"=>"4", "validation"=>"", "choice_form"=>"", "choice_null"=>true, "choice_type"=>"manual", "oai_release"=>false, "placeholder"=>"", "choice_array"=>"Testing,Something Really Cool,Awesome", "local_styles"=>"", "no_duplicates"=>false, "default_choice"=>"", "public_release"=>true, "display_in_list"=>false, "validation_regex"=>"", "choice_form_field"=>"", "disabled_on_insert"=>false, "disabled_on_update"=>false, "metadata_standards"=>[{"schema"=>"Dublin Core", "identifier"=>"idea", "qualifier"=>"magnets"}, {"schema"=>"Dublin Core", "identifier"=>"usage", "qualifier"=>"rightsStatement"}]}
  end 

  let(:user) {  FactoryBot.create(:user, :admin) }

  # shared examples
  context 'inherit parent behaviors without having to redo tests for all items' do
    it_behaves_like 'a field builder' 
    it_behaves_like 'a choice field'
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
    
    it 'should be a select field' do
      fb = described_class.new(field_hash, user, 'insert')
      expect(fb.html).to include('select')
    end 

    it 'should contain options' do
      fb = described_class.new(field_hash, user, 'insert')
      field_hash['choice_array'].split(',').each do |opt|
        expect(fb.html).to include(opt)
      end 
    end 

    it 'should not contain multiple' do 
      fb = described_class.new(field_hash, user, 'insert')
      expect(fb.html).to_not include('multiple')
    end 

    it 'should contain the default value' do
      fb = described_class.new(field_hash, user, 'insert')
      expect(fb.html).to include(fb.data_attributes)
    end
  end 
end