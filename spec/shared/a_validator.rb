RSpec.shared_examples "a validator" do
  include RSpecHtmlMatchers
  
  let(:form) { FactoryBot.create(:form) }

  let(:field_hash) do 
    field_hash = 
    [{"max"=>"", "min"=>"", "name"=>"title", "step"=>"", "type"=>"text", "label"=>"AcquisitionTitle", "value"=>"", "css_id"=>"title", "format"=>"characters", "hidden"=>"", "disabled"=>"false", "field_id"=>"0", "help_url"=>"", "readonly"=>"false", "required"=>"true", "sortable"=>"", "css_class"=>"", "help_info"=>"", "help_type"=>"no_help", "searchable"=>"", "sort_order"=>"0", "validation"=>"", "placeholder"=>"", "local_styles"=>"width:90%;", "no_duplicates"=>"true", "public_release"=>"true", "display_in_list"=>"", "validation_regex"=>"", "disabled_on_insert"=>"false", "disabled_on_update"=>"false", "metadata_standards"=>[]}]
  end 
  
  context '.init' do
    it 'initalizes' do
      base = described_class.new(form.id,'test', 'somestring')
      expect(base).to be_a described_class
    end

    it "assigned @field_id" do
      base = described_class.new(form.id,'test', 'somestring')
      expect(base.instance_variable_defined?(:@field_id)).to be true
    end

    it "assigned @field_name" do
      base = described_class.new(form.id,'test', 'somestring')
      expect(base.instance_variable_defined?(:@field_name)).to be true
    end

    it "assigned @input" do
      base = described_class.new(form.id,'test', 'somestring')
      expect(base.instance_variable_defined?(:@input)).to be true
    end
  end

  context '.valid?' do
    it 'expects all params to be present' do
      base = described_class.new(form.id, nil, nil)
      expect(base.valid?).to be false
    end
    
    it 'expects errors to be present' do
      base = described_class.new(form.id, nil, nil)
      expect(base.valid?).to be false
      expect(base.errors.count).to eq 2
    end 

    it 'excpects a failure' do
      base = described_class.new('12', 'test', 'somestring')
      expect(base.valid?).to be false
      expect(base.errors[:form_id]).to include 'Must be a valid form ID.'
    end 
  end 

  context '.form_field' do 
    it 'gets the field information from the organized hash using fieldname' do
      form.fields = field_hash
      form.save! 
      base = described_class.new(form.id, 'title', 'somestring')
      expect(base.form_field).to eq field_hash.first
    end 

    it 'should be nil because the field_title that is being set does not exist' do
      form.fields = field_hash
      form.save! 
      base = described_class.new(form.id, 'does_not_exist', 'somestring')
      expect(base.form_field).to be_nil
    end 
  end 

end 