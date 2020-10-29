require 'rails_helper'

RSpec.describe Validator::Actor, type: :model do

  let(:form) { FactoryBot.create(:form) }
  let(:field_hash) do 
    field_hash = [{"max"=>"", "min"=>"", "name"=>"title", "step"=>"", "type"=>"text", "label"=>"AcquisitionTitle", "value"=>"", "css_id"=>"title", "format"=>"characters", "hidden"=>"", "disabled"=>"false", "field_id"=>"0", "help_url"=>"", "readonly"=>"false", "required"=>"true", "sortable"=>"", "css_class"=>"", "help_info"=>"", "help_type"=>"no_help", "searchable"=>"", "sort_order"=>"0", "validation"=>"", "placeholder"=>"", "local_styles"=>"width:90%;", "no_duplicates"=>"true", "public_release"=>"true", "display_in_list"=>"", "validation_regex"=>"", "disabled_on_insert"=>"false", "disabled_on_update"=>"false", "metadata_standards"=>[]}]
  end 

  context '.init' do
    it 'initalizes' do
      base = described_class.new(form.id, 'test', 'somestring')
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

  context 'methods' do
    it '.perform' do
      base = described_class.new(form.id, 'test', 'somestring')
      expect(base).reponds_to? :perform
    end

    it '.form' do
      base = described_class.new(form.id, 'test', 'somestring')
      expect(base).reponds_to? :form
    end

    it '.form_field' do
      base = described_class.new(form.id, 'test', 'somestring')
      expect(base).reponds_to? :form_field
    end

    it '.valid_form_object' do
      base = described_class.new(form.id, 'test', 'somestring')
      expect(base).reponds_to? :valid_form_object?
    end
  end
  
  context '.perfom' do
    it 'textarea tests and validations pass' do
      field_hash.first['min'] = '1'
      field_hash.first['max'] = '100'
      field_hash.first['format'] = 'characters'
      form.fields = field_hash
      form.save 
      input = 'testing'
      base = described_class.new(form.id, 'title', input)
      expect(base.perform).to be_a Hash
    end
  end
  
end 