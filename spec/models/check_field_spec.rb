require 'rails_helper'

RSpec.describe CheckField, type: :model do
  let(:check) { CheckField.new }

  context 'shared tests' do
    it_behaves_like 'a field'
    it_behaves_like 'fieldable'
    it_behaves_like 'readonly'
  end

  context 'database columns' do
    context 'checkbox specific' do
      context 'strings' do
        it { should have_db_column(:choices).of_type(:string) }
      end

      context 'integers' do
        it { should have_db_column(:default_choice).of_type(:integer) }
        it { should have_db_column(:default_choice).of_type(:integer) }
      end
    end
  end

  context 'enumeration' do
  end 

  context 'default values' do
    it 'public_release should be true' do
      expect(check.public_release).to be true
    end

    it 'name should be untitled' do
      expect(check.name).to be_a(String)
      expect(check.name.downcase).to eq 'untitled'
    end

    it 'label should be untitled' do
      expect(check.label).to be_a(String)
      expect(check.label.downcase).to eq 'untitled'
    end

    it 'sets types to checkfield' do
      expect(check.type).to be_a(String)
      expect(check.type.downcase).to eq 'checkbox'
    end
  end
end
