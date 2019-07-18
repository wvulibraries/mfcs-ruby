require 'rails_helper'

RSpec.describe Form, type: :model do
  # database fields
  context 'database fields' do
    context 'strings' do
      it { should have_db_column(:title).of_type(:string) }
      it { should have_db_column(:description).of_type(:text) }
      it { should have_db_column(:idno).of_type(:string) }
      it { should have_db_column(:submit_button).of_type(:string) }
      it { should have_db_column(:update_button).of_type(:string) }
      it { should have_db_column(:display_title).of_type(:string) }
      it { should have_db_column(:object_title_field).of_type(:string) }
      it { should have_db_column(:link_title).of_type(:string) }
    end

    context 'booleans' do
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

    context 'navigation' do
      it { should have_db_column(:navigation).of_type(:hstore) }
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

    context 'Form.idno' do
      it { should validate_presence_of(:idno) }
      it { should validate_length_of(:idno).is_at_least(1) }
      it { should validate_length_of(:idno).is_at_most(250) }
      it { should validate_uniqueness_of(:idno) }
    end
  end
  
  # form associations
  context 'associations' do
    it { should have_many :fields }
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
end
