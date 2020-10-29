require 'rails_helper'

RSpec.describe Validator::FieldDuplicate, type: :model do
  let(:form) { FactoryBot.create(:form) }
  let(:field_hash) do 
    field_hash = [{"max"=>"", "min"=>"", "name"=>"title", "step"=>"", "type"=>"text", "label"=>"AcquisitionTitle", "value"=>"", "css_id"=>"title", "format"=>"characters", "hidden"=>"", "disabled"=>"false", "field_id"=>"0", "help_url"=>"", "readonly"=>"false", "required"=>"true", "sortable"=>"", "css_class"=>"", "help_info"=>"", "help_type"=>"no_help", "searchable"=>"", "sort_order"=>"0", "validation"=>"", "placeholder"=>"", "local_styles"=>"width:90%;", "no_duplicates"=>"true", "public_release"=>"true", "display_in_list"=>"", "validation_regex"=>"", "disabled_on_insert"=>"false", "disabled_on_update"=>"false", "metadata_standards"=>[]}]
  end 

  context 'base behaviors' do
    it_behaves_like 'a validator object' 
  end

  context '.required?' do
    it 'returns true because the field_hash is true' do
      base = described_class.new('', field_hash.first, form.id)
      expect(base.required?).to be true 
    end 

    it 'returns false because the field_hash is false' do
      field_hash.first['required'] = false
      base = described_class.new('', field_hash.first, form.id) 
      expect(base.required?).to be false
    end 

    it 'returns false because the field_hash is empty' do
      field_hash.first['required'] = ''
      base = described_class.new('', field_hash.first, form.id) 
      expect(base.required?).to be false
    end 

    it 'returns false because the field_hash is some weird string' do
      field_hash.first['required'] = 'monkey_patching_tacos'
      base = described_class.new('', field_hash.first, form.id) 
      expect(base.required?).to be false
    end 
  end 

  context '.no_duplicates?' do
    it 'returns true because the field_hash is true' do
      base = described_class.new('', field_hash.first, form.id)
      expect(base.no_duplicates?).to be true 
    end 

    it 'returns false because the field_hash is false' do
      field_hash.first['no_duplicates'] = false
      base = described_class.new('', field_hash.first, form.id) 
      expect(base.no_duplicates?).to be false
    end 

    it 'returns false because the field_hash is empty' do
      field_hash.first['no_duplicates'] = ''
      base = described_class.new('', field_hash.first, form.id) 
      expect(base.no_duplicates?).to be false
    end 

    it 'returns false because the field_hash is some weird string' do
      field_hash.first['no_duplicates'] = 'monkey_patching_tacos'
      base = described_class.new('', field_hash.first, form.id) 
      expect(base.no_duplicates?).to be false
    end 
  end 
  
  context '.perform' do
    before(:each) do
      @form = form
      @names = (1..10).map { Faker::Movies::LordOfTheRings.character }.uniq.sort
      @names.each do |title|  
        item = FactoryBot.build(:metadata)
        item.data = {"title" => "#{title}"}
        item.form_id = @form.id
        item.save! 
      end 
    end

    it 'has a title that includes the input' do
      input = Faker::Movies::HitchhikersGuideToTheGalaxy.character
      item = FactoryBot.build(:metadata)
      item.data = {"title" => input}
      item.form_id = @form.id
      item.save! 
      
      dups = described_class.new(input, field_hash.first, @form.id)
      expect(dups.field_data).to include(input)
      expect(dups.perform).to be false
    end
    
    it 'does not have a title that is included in the field data' do
      field_hash.first['no_duplicates'] = false 
      input = Faker::Movies::HitchhikersGuideToTheGalaxy.character
      dups = described_class.new(input, field_hash.first, @form.id)

      expect(dups.field_data).not_to include(input)
      expect(dups.perform).to be true
    end 

    it 'returns true regaurdless because duplicates are not being checked' do
      field_hash.first['no_duplicates'] = false 
      input = Faker::Movies::HitchhikersGuideToTheGalaxy.character
      dups = described_class.new(input, field_hash.first, @form.id)
      expect(dups.perform).to be true
    end 

    it 'returns true regaurdless because the field is not required (this means it would be blank and duplicate blanks would be allowed' do
      field_hash.first['required'] = false 
      input = Faker::Movies::HitchhikersGuideToTheGalaxy.character
      dups = described_class.new(input, field_hash.first, @form.id)
      expect(dups.perform).to be true
    end
  end 

  context '.field_data' do
    before(:each) do
      @form = FactoryBot.create(:form)
      @names = (1..10).map { Faker::Movies::LordOfTheRings.character }.uniq.sort
      @names.each do |title|  
        item = FactoryBot.build(:metadata)
        item.data = {"title" => "#{title}"}
        item.form_id = @form.id
        item.save! 
      end 
    end
    
    it 'expeects the set to include the input' do
      input = Faker::Movies::HitchhikersGuideToTheGalaxy.character
      item = FactoryBot.build(:metadata)
      item.data = {"title" => input}
      item.form_id = @form.id
      item.save! 
      
      dups = described_class.new(input, field_hash.first, @form.id)
      expect(dups.field_data).to include(input)
    end 

    it 'returns the data as a set associated with the form_id' do
      input = Faker::Movies::HitchhikersGuideToTheGalaxy.character
      dups = described_class.new(input, field_hash.first, @form.id)
      expect(dups.field_data).to be_a Set
      expect(dups.field_data.count).to eq @names.count 
    end

    it 'returns an empty set' do 
      Item.delete_all
      input = Faker::Movies::HitchhikersGuideToTheGalaxy.character
      dups = described_class.new(input, field_hash.first, @form.id)
      expect(dups.field_data).to be_a Set
      expect(dups.field_data).to be_empty 
    end 
  end
end 