require 'rails_helper'
require './spec/shared/a_field'

RSpec.describe TextField, type: :model do
  let(:text) { TextField.new }

  context 'database columns' do
    # covers all default field items
    it_behaves_like 'a field'

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
  end
end
