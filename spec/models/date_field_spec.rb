require 'rails_helper'

RSpec.describe DateField, type: :model do
  let(:date) { DateField.new }

  context 'shared tests' do
    it_behaves_like 'a field'
    it_behaves_like 'fieldable'
  end

  context 'database specific' do
    it { should have_db_column(:validation).of_type(:string) }
  end

  context 'defaults' do
    it 'public_release should be true' do
      expect(date.public_release).to be true
    end

    it 'name should be untitled' do
      expect(date.name).to be_a(String)
      expect(date.name.downcase).to eq 'untitled'
    end

    it 'label should be untitled' do
      expect(date.label).to be_a(String)
      expect(date.label.downcase).to eq 'untitled'
    end

    it 'sets types to integer' do
      expect(date.type).to be_a(String)
      expect(date.type.downcase).to eq 'date'
    end

    it 'sets validation to integer' do
      expect(date.validation).to be_a(String)
      expect(date.validation.downcase).to eq 'date'
    end
  end
end
