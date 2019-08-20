require 'rails_helper'

RSpec.describe WebsiteField, type: :model do
  let(:web) { WebsiteField.new }

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
      expect(web.public_release).to be true
    end

    it 'name should be untitled' do
      expect(web.name).to be_a(String)
      expect(web.name.downcase).to eq 'untitled'
    end

    it 'label should be untitled' do
      expect(web.label).to be_a(String)
      expect(web.label.downcase).to eq 'untitled'
    end

    it 'sets types to integer' do
      expect(web.type).to be_a(String)
      expect(web.type.downcase).to eq 'website'
    end

    it 'sets validation to integer' do
      expect(web.validation).to be_a(String)
      expect(web.validation.downcase).to eq 'url'
    end
  end
end
