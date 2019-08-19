require 'rails_helper'

RSpec.describe Project, type: :model do
  context 'database columns' do
    it { should have_db_column(:name).of_type(:string) }
    it { should have_db_column(:project_id).of_type(:string) }
  end
end
