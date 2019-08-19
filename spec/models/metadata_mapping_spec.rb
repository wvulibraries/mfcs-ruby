require 'rails_helper'

RSpec.describe MetadataMapping, type: :model do
  context 'database columns' do
    it { should have_db_column(:schema).of_type(:integer) }
    it { should have_db_column(:identifier).of_type(:string) }
    it { should have_db_column(:qualifier).of_type(:string) }
  end

  context 'enum' do
    schema = { '0' => 'Dublin Core' }
    it { should define_enum_for(:schema).with_values(schema) }
  end
end
