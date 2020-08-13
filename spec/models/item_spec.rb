# == Schema Information
#
# Table name: items
#
#  id             :bigint           not null, primary key
#  data           :jsonb
#  idno           :string
#  metadata       :boolean
#  public_release :boolean
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  form_id        :integer
#
require 'rails_helper'

RSpec.describe Item, type: :model do
  let(:metadata_item) { FactoryBot.create :metadata }
  let(:item) { FactoryBot.create :object }

  # Database Columns 
  # ================================================================
  context 'database columns' do
    it { should have_db_column(:id).of_type(:integer) }
    it { should have_db_column(:data).of_type(:jsonb) }
    it { should have_db_column(:idno).of_type(:string) }
    it { should have_db_column(:metadata).of_type(:boolean) }
    it { should have_db_column(:public_release).of_type(:boolean) }
    it { should have_db_column(:created_at).of_type(:datetime) }
    it { should have_db_column(:updated_at).of_type(:datetime) }
    it { should have_db_column(:form_id).of_type(:integer) }
  end
  
  # Associations
  # ================================================================
  context 'associations' do
    it { should belong_to(:form) }
  end

  # Shared Tests
  # ================================================================
  context 'shared examples' do
    it_behaves_like 'readonly'
  end
  
  # Database Examples 
  # ================================================================
  context 'audits' do
    it 'Should respond to audit methods' do
      expect(metadata_item.respond_to?(:audits)).to be true
    end
  end 
end
