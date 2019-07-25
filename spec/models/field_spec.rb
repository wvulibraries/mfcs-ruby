require 'rails_helper'
require './spec/shared/a_field'

RSpec.describe Field, type: :model do
  it_behaves_like 'a field'

  context 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:type) }
    it { should validate_presence_of(:label) }
  end

  context 'associations' do
    it { should have_db_column(:formable_id).of_type(:integer) }
    it { should have_db_column(:formable_type).of_type(:string) }
    it { should belong_to(:formable) }
  end
end
