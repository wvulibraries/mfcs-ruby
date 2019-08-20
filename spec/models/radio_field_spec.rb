require 'rails_helper'

RSpec.describe RadioField, type: :model do
  let(:radio) { RadioField.new }

  context 'shared tests' do
    it_behaves_like 'a field'
    it_behaves_like 'fieldable'
    it_behaves_like 'readonly'
  end

  context 'database columns' do
    context 'radio button specific' do
      context 'strings' do
        it { should have_db_column(:choices).of_type(:string) }
      end

      context 'integers' do
        it { should have_db_column(:default_choice).of_type(:integer) }
      end
    end
  end

  context 'default values' do
    it 'public_release should be true' do
      expect(radio.public_release).to be true
    end

    it 'name should be untitled' do
      expect(radio.name).to be_a(String)
      expect(radio.name.downcase).to eq 'untitled'
    end

    it 'label should be untitled' do
      expect(radio.label).to be_a(String)
      expect(radio.label.downcase).to eq 'untitled'
    end

    it 'sets types to radiofield' do
      expect(radio.type).to be_a(String)
      expect(radio.type.downcase).to eq 'radio'
    end
  end
end
