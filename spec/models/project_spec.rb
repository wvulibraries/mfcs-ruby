require 'rails_helper'

RSpec.describe Project, type: :model do
  # shared examples 
  context 'shared examples' do
    it_behaves_like 'readonly'
    it_behaves_like 'a valid factory' # factorybot
  end
  
  context 'database columns' do
    it { should have_db_column(:name).of_type(:string) }
    it { should have_db_column(:project_id).of_type(:string) }
  end
end
