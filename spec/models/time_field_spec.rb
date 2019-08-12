require 'rails_helper'

RSpec.describe TimeField, type: :model do
  let(:time) { TimeField.new }

  context 'shared tests' do
    it_behaves_like 'a field'
    it_behaves_like 'fieldable'
  end

  context 'database specific' do
    it { should have_db_column(:validation).of_type(:string) }
  end

  context 'defaults' do
    it 'public_release should be true' do
      expect(time.public_release).to be true
    end

    it 'name should be untitled' do
      expect(time.name).to be_a(String)
      expect(time.name.downcase).to eq 'untitled'
    end

    it 'label should be untitled' do
      expect(time.label).to be_a(String)
      expect(time.label.downcase).to eq 'untitled'
    end

    it 'sets types to integer' do
      expect(time.type).to be_a(String)
      expect(time.type.downcase).to eq 'time'
    end

    it 'sets validation to integer' do
      expect(time.validation).to be_a(String)
      expect(time.validation.downcase).to eq 'time'
    end
  end
end
