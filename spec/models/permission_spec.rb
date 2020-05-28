# == Schema Information
#
# Table name: permissions
#
#  id         :bigint           not null, primary key
#  permission :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  form_id    :bigint           not null
#  user_id    :bigint           not null
#
# Indexes
#
#  index_permissions_on_form_id  (form_id)
#  index_permissions_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (form_id => forms.id)
#  fk_rails_...  (user_id => users.id)
#
require 'rails_helper'

RSpec.describe Permission, type: :model do
  # shared examples
  # these do not work currently because of the explicit need for associations 
  # context 'shared examples' do
  #   it_behaves_like 'readonly'
  #   it_behaves_like 'a valid factory' # factorybot
  # end

  # Factories 
  let(:permission) { FactoryBot.create :permission }
  let(:system) {  System.new(name: 'readonly', value: true) }
  let(:permission_unsaved) { FactoryBot.build :permission }
  
  # database fields
  context 'database fields' do
    context 'integer' do 
      it { should have_db_column(:permission).of_type(:integer) }
    end

    context 'associations' do 
      it { should belong_to :form }
      it { should belong_to :user } 
    end
    
    context 'enums' do
      it { should define_enum_for(:permission).with_values(admin: 3, viewer: 1, creator: 2, contact: 4) }
    end 
  end 

  # context 
  context 'valid factory' do
    it 'should be a valid factory' do
      expect(permission.valid?).to be true
    end 
    it 'should have a valid user' do
      expect(permission.user).to be_a User
    end 
    it 'should have a valid form' do
      expect(permission.form).to be_a Form
    end 
  end 

  context 'readonly' do
    it 'does not save new' do
      system.save
      expect {permission_unsaved.save(validate: false) }.to raise_error(ActiveRecord::ReadOnlyRecord)
    end

    it 'does not update existing' do
      permission # builds new before system is turned off
      system.save
      permission.updated_at = Time.now
      expect { permission.save(validate: false) }.to raise_error(ActiveRecord::ReadOnlyRecord)
    end

    it 'does not delete' do
      permission # builds new before system is turned off
      system.save
      expect { permission.destroy }.to raise_error(ActiveRecord::ReadOnlyRecord)
    end
  end 
end
