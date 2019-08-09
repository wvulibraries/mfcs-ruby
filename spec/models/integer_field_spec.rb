require 'rails_helper'

RSpec.describe IntegerField, type: :model do
  let(:int) { IntegerField.new }

  context 'shared tests' do
    it_behaves_like 'a field'
    it_behaves_like 'fieldable'
  end

  context 'database specific' do
    context 'integer field specific' do
      it { should have_db_column(:validation).of_type(:string) }
      it { should have_db_column(:min).of_type(:integer) }
      it { should have_db_column(:max).of_type(:integer) }
      it { should have_db_column(:step).of_type(:integer) }
    end
  end

  context 'defaults' do
    it 'public_release should be true' do
      expect(int.public_release).to be true
    end

    it 'name should be untitled' do
      expect(int.name).to be_a(String)
      expect(int.name.downcase).to eq 'untitled'
    end

    it 'label should be untitled' do
      expect(int.label).to be_a(String)
      expect(int.label.downcase).to eq 'untitled'
    end

    it 'sets types to integer' do
      expect(int.type).to be_a(String)
      expect(int.type.downcase).to eq 'integer'
    end

    it 'sets validation to integer' do
      expect(int.validation).to be_a(String)
      expect(int.validation.downcase).to eq 'integer'
    end
  end
end
