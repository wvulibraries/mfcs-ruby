require 'rails_helper'

RSpec.describe Field, type: :model do
  # shared examples
  context 'shared examples' do
    it_behaves_like 'readonly'
  end

  context 'Database' do
    it { should have_db_column(:field_types_type).of_type(:string) }
    it { should have_db_column(:field_types_id).of_type(:integer) }
    it { should have_db_column(:form_id).of_type(:integer) }
    it { should have_db_column(:position).of_type(:integer) }
  end

  context 'Association' do
    it { should belong_to(:field_types) }
    it { should have_many(:metadata_mappings) }
  end
end
