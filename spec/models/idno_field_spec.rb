require 'rails_helper'

RSpec.describe IdnoField, type: :model do
  let(:idno) { IdnoField.new }

  context 'shared tests' do
    it_behaves_like 'a field' # covers all default field items
    it_behaves_like 'fieldable' # linking of fields to form
    it_behaves_like 'readonly' # readonly mode
    it_behaves_like 'a valid factory' # factorybot
    it_behaves_like 'helpable' # logic for help enumerations
  end 

  context 'database columns' do
    context 'idno field specific' do
      context 'strings' do
        it { should have_db_column(:validation).of_type(:string) }
        it { should have_db_column(:validation_regex).of_type(:string) }
        it { should have_db_column(:placeholder).of_type(:string) }
        it { should have_db_column(:idno_format).of_type(:string) }
      end

      context 'integers' do
        it { should have_db_column(:numbering_type).of_type(:integer) }
        it { should have_db_column(:start_increment).of_type(:integer) }
      end
    end
  end

  context 'enumerations' do
    it { should define_enum_for(:numbering_type) }
    it { should define_enum_for(:numbering_type).with_values('user' => 0, 'system' => 1) }
  end

  context 'default values' do
    it 'required should be true' do
      expect(idno.required).to be true
    end

    it 'no duplicates should be true' do
      expect(idno.no_duplicates).to be true
    end

    it 'read_only should be true' do
      expect(idno.read_only).to be true
    end

    it 'public_release should be true' do
      expect(idno.public_release).to be true
    end

    it 'oai_release should be true' do
      expect(idno.oai_release).to be true
    end

    it 'sortable should be true' do
      expect(idno.sortable).to be true
    end

    it 'searchable should be true' do
      expect(idno.searchable).to be true
    end

    it 'display_in_list should be true' do
      expect(idno.display_in_list).to be true
    end

    it 'name should be set to idno and be a string' do
      expect(idno.name).to be_a(String)
      expect(idno.name).to eq 'idno'
    end

    it 'label should be set to IDNO and be a string' do
      expect(idno.name).to be_a(String)
      expect(idno.label).to eq 'IDNO'
    end

    it 'css_id should be set to idno and be a string' do
      expect(idno.name).to be_a(String)
      expect(idno.css_id).to eq 'idno'
    end

    it 'type should be set to idno' do
      expect(idno.type).to be_a(String)
      expect(idno.type).to eq 'idno'
    end
  end
end
