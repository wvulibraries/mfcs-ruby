require 'rails_helper'

RSpec.describe PhoneField, type: :model do
  let(:phone) { PhoneField.new }

  context 'shared tests' do
    it_behaves_like 'a field'
    it_behaves_like 'fieldable'
    it_behaves_like 'readonly'
    it_behaves_like 'a valid factory' # factorybot
  end

  context 'database specific' do
    it { should have_db_column(:validation).of_type(:string) }
  end

  context 'defaults' do
    it 'public_release should be true' do
      expect(phone.public_release).to be true
    end

    it 'name should be untitled' do
      expect(phone.name).to be_a(String)
      expect(phone.name.downcase).to eq 'untitled'
    end

    it 'label should be untitled' do
      expect(phone.label).to be_a(String)
      expect(phone.label.downcase).to eq 'untitled'
    end

    it 'sets types to integer' do
      expect(phone.type).to be_a(String)
      expect(phone.type.downcase).to eq 'phone'
    end

    it 'sets validation to integer' do
      expect(phone.validation).to be_a(String)
      expect(phone.validation.downcase).to eq 'phone'
    end
  end
end
