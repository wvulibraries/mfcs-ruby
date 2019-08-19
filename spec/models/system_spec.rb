require 'rails_helper'

RSpec.describe System, type: :model do
  context 'database columns' do
    it { should have_db_column(:name).of_type(:string) }
    it { should have_db_column(:value).of_type(:boolean) }
  end

  context '.check' do
    it 'sets a readonly value to true' do
      system = System.new(name: 'readonly', value: true)
      system.save!
      expect(System.check('readonly')).to eq true
    end

    it 'sets a readonly value to false' do
      system = System.new(name: 'readonly', value: false)
      system.save!
      expect(System.check('readonly')).to eq false
    end

    it 'nil value for readonly should return false' do
      System.delete_all # delete everything just in case
      expect(System.check('readonly')).to eq false
    end 
  end
end
