require 'rails_helper'

RSpec.describe EmailField, type: :model do
  let(:email) { EmailField.new }

  context 'shared tests' do
    it_behaves_like 'a field'
    it_behaves_like 'fieldable'
    it_behaves_like 'readonly'
  end

  context 'database specific' do
    it { should have_db_column(:validation).of_type(:string) }
  end

  context 'defaults' do
    it 'public_release should be true' do
      expect(email.public_release).to be true
    end

    it 'name should be untitled' do
      expect(email.name).to be_a(String)
      expect(email.name.downcase).to eq 'untitled'
    end

    it 'label should be untitled' do
      expect(email.label).to be_a(String)
      expect(email.label.downcase).to eq 'untitled'
    end

    it 'sets types to integer' do
      expect(email.type).to be_a(String)
      expect(email.type.downcase).to eq 'email'
    end

    it 'sets validation to integer' do
      expect(email.validation).to be_a(String)
      expect(email.validation.downcase).to eq 'email'
    end
  end
end
