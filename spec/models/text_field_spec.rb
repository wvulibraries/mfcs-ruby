require 'rails_helper'
require './spec/shared/a_field'

RSpec.describe TextField, type: :model do
  let(:text) { TextField.new }

  context 'shared tests' do
    it_behaves_like 'a field'
    it_behaves_like 'fieldable'
    it_behaves_like 'readonly'
    it_behaves_like 'a valid factory' # factorybot
  end 

  context 'database columns' do
    context 'text field specific' do
      context 'strings' do
        it { should have_db_column(:validation).of_type(:string) }
        it { should have_db_column(:validation_regex).of_type(:string) }
        it { should have_db_column(:placeholder).of_type(:string) }
      end

      context 'integers' do
        it { should have_db_column(:min).of_type(:integer) }
        it { should have_db_column(:max).of_type(:integer) }
        it { should have_db_column(:format).of_type(:integer) }
      end
    end
  end

  context 'enumerations' do
    it { should define_enum_for(:format) }
    it { should define_enum_for(:format).with_values('Characters' => 0, 'Words' => 1) }
  end

  context 'default values' do
    it 'public_release should be true' do
      expect(text.public_release).to be true
    end

    it 'name should be untitled' do
      expect(text.name).to be_a(String)
      expect(text.name.downcase).to eq 'untitled'
    end 

    it 'label should be untitled' do
      expect(text.label).to be_a(String)
      expect(text.label.downcase).to eq 'untitled'
    end

    it 'sets types to Text' do
      expect(text.type).to be_a(String)
      expect(text.type.downcase).to eq 'text'
    end
  end

  context 'FactoryBot testing' do
    it 'has a valid factory' do
      factory_idno = FactoryBot.build(:idno_field)
      expect(factory_idno).to be_valid
    end
  end
end
