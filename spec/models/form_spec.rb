require 'rails_helper'
require 'json'

RSpec.describe Form, type: :model do
  # shared examples 
  context 'shared examples' do
    it_behaves_like 'readonly'
    it_behaves_like 'a valid factory' # factorybot
  end
  
  # database fields
  context 'database fields' do
    context 'strings' do
      it { should have_db_column(:title).of_type(:string) }
      it { should have_db_column(:description).of_type(:text) }
      it { should have_db_column(:submit_button).of_type(:string) }
      it { should have_db_column(:update_button).of_type(:string) }
      it { should have_db_column(:display_title).of_type(:string) }
      it { should have_db_column(:object_title_field).of_type(:string) }
      it { should have_db_column(:link_title).of_type(:string) }
    end

    context 'booleans' do
      it { should have_db_column(:production).of_type(:boolean) }
      it { should have_db_column(:container).of_type(:boolean) }
      it { should have_db_column(:metadata).of_type(:boolean) }
      it { should have_db_column(:export_public).of_type(:boolean) }
      it { should have_db_column(:export_oai).of_type(:boolean) }
      it { should have_db_column(:object_public_release_default).of_type(:boolean) }
      it { should have_db_column(:object_public_release_show).of_type(:boolean) }
    end

    context 'integers' do
      it { should have_db_column(:count).of_type(:integer) }
    end

    context 'datestamps' do
      it { should have_db_column(:created_at).of_type(:datetime) }
      it { should have_db_column(:updated_at).of_type(:datetime) }
    end

    context 'hstores' do
      it { should have_db_column(:navigation).of_type(:hstore) }
      it { should have_db_column(:fields).of_type(:jsonb) }
      it { should have_db_column(:permissions).of_type(:hstore) }
      it { should have_db_column(:idno).of_type(:hstore) }
    end
  end

  # validations
  context 'validations' do
    context 'Form.title' do
      it { should validate_presence_of(:title) }
      it { should validate_length_of(:title).is_at_least(1) }
      it { should validate_length_of(:title).is_at_most(250) }
      it { should validate_uniqueness_of(:title) }
    end

    context 'Form.display_title' do
      it { should validate_presence_of(:display_title) }
      it { should validate_length_of(:display_title).is_at_least(1) }
      it { should validate_length_of(:display_title).is_at_most(250) }
      it { should validate_uniqueness_of(:display_title) }
    end
  end

  # set defaults
  context 'defaults' do
    it 'should init and set default values' do
      form = Form.new # init
      expect(form.submit_button).to eq('Submit')
      expect(form.update_button).to eq('Update')
      expect(form.container).to be false
      expect(form.production).to be true
      expect(form.export_public).to be true
      expect(form.export_oai).to be true
    end
  end

  # settings some json field data 
  context 'imported data' do
    it 'valid json production data that will save in the database' do
      form_data = JSON.parse(file_fixture('pec.json').read)
      f = Form.new(form_data)
      expect(f.valid?).to be true
      expect(f.save).to be true
    end
  end

  context '.linked_forms' do
    it 'expects nil for a non hash object' do
      data = FactoryBot.build(:form)
      puts data.linked_forms.inspect
      expect(data.linked_forms).to be nil
    end

    it 'expects empty array for items without links' do
      data = FactoryBot.build(:form)
      data.fields = { item: 'testing', idno: '192848;dflkjadsf' }
      expect(data.linked_forms).to be_a Array
      expect(data.linked_forms).to eq []
    end

    it 'expects an array of integers from productions style data' do
      form_data = JSON.parse(file_fixture('pec.json').read)
      f = Form.new(form_data)
      expect(f.linked_forms).to eq([1, 3, 4, 5, 6, 9, 10, 11, 12, 13, 14])
    end
  end

  context 'scopes' do
    context '.object_forms' do
      it 'expects it to include the form' do
        data = FactoryBot.build(:form)
        data.metadata = false
        data.save 
        expect(Form.object_forms).to include(data)
      end 

      it 'expects it to include the form' do
        data = FactoryBot.build(:form)
        data.metadata = true
        data.save 
        expect(Form.object_forms).to_not include(data)
      end
    end

    context '.metadata_forms' do
      it 'expects it to include the form' do
        data = FactoryBot.build(:form)
        data.metadata = true
        data.save 
        expect(Form.metadata_forms).to include(data)
      end 

      it 'expects it to include the form' do
        data = FactoryBot.build(:form)
        data.metadata = false
        data.save 
        expect(Form.metadata_forms).to_not include(data)
      end
    end
  end

end
