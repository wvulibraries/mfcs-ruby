require 'rails_helper'

RSpec.describe FieldBuilder::Presenter, type: :model do
  let(:field_hash) do 
    field_hash = { "name"=>"idno", "type"=>"idno", "label"=>"Identifier", "value"=>"idno_testing", "hidden"=>"false", "disabled"=>"false", "field_id"=>"6815100000007078", "required"=>"true", "sortable"=>"true", "help_type"=>"", "read_only"=>"false", "managed_by"=>"User", "searchable"=>"true", "sort_order"=>1, "validation"=>"", "idno_format"=>"", "oai_release"=>"true", "placeholder"=>"testing placeholder", "public_release"=>"true", "display_in_list"=>"true", "start_increment"=>"1", "validation_regex"=>"", "disabled_on_insert"=>"false", "disabled_on_update"=>"false", "metadata_standards"=>[] }
  end 

  let(:current_user) {  FactoryBot.create(:user, :admin) }

  context 'Return the proper class type' do
    it 'return Idno' do
      field_hash['type'] = 'idno'
      presenter = FieldBuilder::Presenter.new(field_hash, 'disabled', current_user)
      expect(presenter.type.class).to be FieldBuilder::IdnoField
    end 

    it 'return text' do
      field_hash['type'] = 'text'
      presenter = FieldBuilder::Presenter.new(field_hash, 'disabled', current_user)
      expect(presenter.type.class).to be FieldBuilder::TextField
    end 

    it 'return textarea' do
      field_hash['type'] = 'textarea'
      presenter = FieldBuilder::Presenter.new(field_hash, 'disabled', current_user)
      expect(presenter.type.class).to be FieldBuilder::TextareaField
    end 

    it 'return Number' do
      field_hash['type'] = 'number'
      presenter = FieldBuilder::Presenter.new(field_hash, 'disabled', current_user)
      expect(presenter.type.class).to be FieldBuilder::NumberField
    end 

    it 'return Select' do
      field_hash['type'] = 'select'
      presenter = FieldBuilder::Presenter.new(field_hash, 'disabled', current_user)
      expect(presenter.type.class).to be FieldBuilder::SelectField
    end 

    it 'return Multiselect' do
      field_hash['type'] = 'multiselect'
      presenter = FieldBuilder::Presenter.new(field_hash, 'disabled', current_user)
      expect(presenter.type.class).to be FieldBuilder::MultiSelectField
    end 

    it 'return Wysiwyg' do
      field_hash['type'] = 'wysiwyg'
      presenter = FieldBuilder::Presenter.new(field_hash, 'disabled', current_user)
      expect(presenter.type.class).to be FieldBuilder::WysiwygField
    end 

    it 'return File Upload' do
      field_hash['type'] = 'file'
      presenter = FieldBuilder::Presenter.new(field_hash, 'disabled', current_user)
      expect(presenter.type.class).to be FieldBuilder::FileUploadField
    end 
  end  
end