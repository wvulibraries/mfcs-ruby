RSpec.shared_examples "a text field" do
  include RSpecHtmlMatchers

  let(:field_hash) do 
    field_hash = {"max"=>"200", "min"=>"5", "name"=>"this_needs_changed", "type"=>"textarea", "label"=>"Some Cool Field", "value"=>"test %date%, by: %username% (%firstname% %lastname%)", "css_id"=>"testing", "format"=>"characters", "hidden"=>false, "disabled"=>false, "field_id"=>"5656465000007302", "help_url"=>"", "required"=>true, "sortable"=>true, "css_class"=>"testing", "help_info"=>"Testing this out too", "help_type"=>"plain_text", "read_only"=>false, "searchable"=>true, "sort_order"=>"3", "validation"=>"", "oai_release"=>true, "placeholder"=>"Untitled Text", "local_styles"=>"background:green", "no_duplicates"=>false, "public_release"=>false, "display_in_list"=>true, "validation_regex"=>"", "disabled_on_insert"=>false, "disabled_on_update"=>false, "metadata_standards"=>[{"schema"=>"Dublin Core", "identifier"=>"description", "qualifier"=>"abstract"}, {"schema"=>"Dublin Core", "identifier"=>"description", "qualifier"=>""}]}
  end 

  let(:user) {  FactoryBot.create(:user, :admin) }

  context '.default_value' do
    it 'should have a value' do
      field_hash['value'] = "something darkside"
      fb = described_class.new(field_hash, user)
      expect(fb.default_value).to be_truthy
    end

    it 'should parse the value to the proper date' do 
      field_hash['value'] = "%date%"
      fb = described_class.new(field_hash, user)
      expect(fb.default_value).to_not include('%date%')
    end 
  end 

  # context '.length_validation' do
  #   it 'should contain a min/max data attribute' do
  #     field_hash['min'] = "1"
  #     field_hash['max'] = "1000"
  #     fb = described_class.new(field_hash, user)
  #     expect(fb.length_validation).to include('data-min')
  #     expect(fb.length_validation).to include('data-max')
  #     expect(fb.length_validation).to include('data-format')
  #   end
  # end
end 