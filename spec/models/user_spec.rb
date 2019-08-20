require 'rails_helper'

RSpec.describe User, type: :model do
  # factory
  let(:user) { FactoryBot.create :user }
  let(:admin) { FactoryBot.create :user, :admin }

  # shared examples 
  context 'shared examples' do
    it_behaves_like 'readonly'
  end

  # validations
  context 'validations' do
    context 'User.first_name' do
      it { should validate_presence_of(:first_name) }
      it { should validate_length_of(:first_name).is_at_least(2) }
      it { should validate_length_of(:first_name).is_at_most(70) }
    end

    context 'User.last_name' do
      it { should validate_presence_of(:last_name) }
      it { should validate_length_of(:last_name).is_at_least(2) }
      it { should validate_length_of(:last_name).is_at_most(70) }
    end

    context 'User.username' do
      it { should validate_presence_of(:username) }
      it { should validate_length_of(:username).is_at_least(2) }
      it { should validate_length_of(:username).is_at_most(70) }
    end
  end

  # enumerations
  context 'enumerations' do
    it { should define_enum_for(:status).with_values(%i[user editor admin]) }
  end

  # base factory tests
  context 'User Factory Bot' do
    it 'User.valid?' do
      expect(user.valid?).to be true
    end
  end

  # boolean tests
  context 'Basic Booleans' do
    it 'User.active?' do
      expect(user.active?).to be true
    end

    it 'User.student?' do
      expect(user.student).to be false
    end

    it 'User.form_creator?' do
      expect(user.form_creator?).to be false
    end
  end

  # Admins
  context 'Admin Values in the User Model' do
    context 'status values' do
      it 'User.admin?' do
        expect(admin.admin?).to be true
      end

      it 'User.active?' do
        expect(admin.active?).to be true
      end

      it 'User.status to equal admin' do
        expect(admin.status).to eq('admin')
      end
    end
  end
end
