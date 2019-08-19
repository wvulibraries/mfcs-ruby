require 'rails_helper'

RSpec.describe SelectField, type: :model do
  let(:select) { SelectField.new }
  context 'shared tests' do
    it_behaves_like 'a field'
    it_behaves_like 'fieldable'
  end

  context 'database columns' do
    it { should have_db_column(:choices).of_type(:string) }
    it { should have_db_column(:default_choice).of_type(:integer) }
    it { should have_db_column(:choice_type).of_type(:integer) }
    it { should have_db_column(:choice_form_id).of_type(:integer) }
    it { should have_db_column(:choice_form_field).of_type(:integer) }
  end

  context 'enum' do
    it { should define_enum_for(:choice_type).with_values(%i[manual form]) }
  end

  context 'default values' do
    it 'public_release should be true' do
      expect(select.public_release).to be true
    end

    it 'name should be untitled' do
      expect(select.name).to be_a(String)
      expect(select.name.downcase).to eq 'untitled'
    end

    it 'label should be untitled' do
      expect(select.label).to be_a(String)
      expect(select.label.downcase).to eq 'untitled'
    end

    it 'sets types to select field' do
      expect(select.type).to be_a(String)
      expect(select.type.downcase).to eq 'select'
    end

    it 'sets default to manual' do
      expect(select.choice_type.downcase).to eq 'manual'
    end
  end
end
