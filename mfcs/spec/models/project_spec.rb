# == Schema Information
#
# Table name: projects
#
#  id         :bigint           not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  project_id :string
#
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
