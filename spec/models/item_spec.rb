# == Schema Information
#
# Table name: items
#
#  id             :bigint           not null, primary key
#  created_by     :integer
#  data           :jsonb
#  idno           :string
#  metadata       :boolean
#  modified_by    :integer
#  public_release :boolean
#  uuid           :string
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  form_id        :integer
#
require 'rails_helper'

RSpec.describe Item, type: :model do
  let(:metadata_item) { FactoryBot.build_stubbed :metadata }
  let(:item) { FactoryBot.build_stubbed :item_object }
  let(:system) {  System.new(name: 'readonly', value: true) }

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
    it { should have_db_column(:uuid).of_type(:string) }
  end
  
  # Associations
  # ================================================================
  context 'associations' do
    it { should belong_to(:form) }
  end

  # Readonly
  # ================================================================
  context 'locked database should not save' do
    before(:each) do 
      @klass = FactoryBot.build(:complete_digital_object_system)
    end 

    it 'does not save new' do
      system.save
      expect { @klass.save(validate: false) }.to raise_error(ActiveRecord::ReadOnlyRecord)
    end

    it 'does not update existing' do
      @klass.save(validate: false) # save class to use later
      system.save
      @klass.updated_at = Time.now
      expect { @klass.save(validate: false) }.to raise_error(ActiveRecord::ReadOnlyRecord)
    end

    it 'does not delete' do
      @klass.save(validate: false) # save class to use later
      system.save
      expect { @klass.destroy }.to raise_error(ActiveRecord::ReadOnlyRecord)
    end
  end

  context 'unlocked database should save' do
    before(:each) do 
      @klass = FactoryBot.build(:complete_digital_object_system)
      @klass.form.save
    end 

    it 'saves new' do
      system.value = false
      system.save
      @klass = FactoryBot.build(:complete_digital_object_system)
      @klass.form.save
      expect(@klass.save(validate: false)).to be_truthy
    end

    it 'updates existing' do
      @klass.save(validate: false) # save class to use later
      system.value = false
      system.save
      @klass.updated_at = Time.now
      expect(@klass.save(validate: false)).to be_truthy
    end

    it 'deletes' do
      @klass.save(validate: false) # save class to use later
      system.value = false
      system.save
      expect(@klass.destroy).to be_truthy
    end
  end
  
  # Database Examples 
  # ================================================================
  context 'audits' do
    it 'Should respond to audit methods' do
      expect(metadata_item.respond_to?(:audits)).to be true
    end
  end 

  context '.custom_data_entry' do
    it 'creating a new item that is not persisted works as valid' do
      item = FactoryBot.build(:complete_digital_object_user)
      item.form.save # saves form first so the item can be saved
      expect(item.valid?).to be true
    end 

    it 'updating an item should save properly' do
      item = FactoryBot.create(:complete_digital_object_user)
      item.data['title'] = Faker::Movies::LordOfTheRings.character
      expect(item.valid?).to be true
    end 

    it 'should delete properly' do 
      item = FactoryBot.create(:complete_digital_object_user) 
      item.delete
      expect(Item.where(id: item.id)).to be_empty
    end 

    it 'should an item has duplicates and is not valid' do
      item = FactoryBot.create(:complete_digital_object_user)
      form = item.form
      new_item = FactoryBot.build(:complete_digital_object_user)
      new_item.form = form 
      expect(new_item.valid?).to be false
      expect(new_item.errors).to_not be_nil 
    end 
  end

  context '.idno_setups' do
    it 'metadata item should return a nil or empty object' do
      item = FactoryBot.build_stubbed(:complete_metadata_object)
      item.idno_setups

      expect(item.idno).to be_nil
    end 

    it 'object managed by system, should set the idno field on the model' do
      item = FactoryBot.build_stubbed(:complete_digital_object_system) 
      item.idno_setups

      expect(item.idno).to be_a String 
      expect(item.idno).to eq('testing_000000003_doh')
      expect(item.idno).to eq(item.data['idno'])
    end 

    it 'object managed by user, idno information data to set on idno' do
      item = FactoryBot.build_stubbed(:complete_digital_object_user) 
      item.idno_setups

      expect(item.idno).to be_a String 
      expect(item.idno).to eq('sweet_idno_number_user_gen')
      expect(item.idno).to eq(item.data['idno'])
    end 
  end 

  context '.idno_set?' do
    it 'should be false because idno_setups has not been run yet' do
      item = FactoryBot.build(:complete_digital_object_user)
      expect(item.idno_set?).to be false
    end

    it 'should be true because the setups has been run' do
      item = FactoryBot.build(:complete_digital_object_user)
      item.idno_setups
      expect(item.idno_set?).to be true
    end 
  end

  # UUID
  # ================================================================
  context 'Default UUID' do
    it 'expects the uuid to be generated' do
      expect(item.uuid).to be_a String
    end 

    it 'exepects the uuid to be 36 characters' do
      expect(item.uuid.length).to eq 36
    end 

    it 'expects uuid to stay the same after a save' do
      item = FactoryBot.build(:complete_digital_object_system)
      #puts item.inspect
      uuid = item.uuid
      item.data['title'] = 'testing.txt'
      item.save validate: false
      expect(item.uuid).to eq uuid  
    end 
  end

  # File Paths
  # ===============================================================
  context '.archival_path' do
    it 'should return a pathname' do
      expect(item.archival_path).to be_a Pathname  
    end 

    it 'should contain form_id' do
      expect(item.archival_path.to_s).to include item.form_id.to_s
    end 

    it 'should contain uuid_path' do
      expect(item.archival_path.to_s).to include item.uuid_path
    end 

    it 'should contain data/archives' do
      expect(item.archival_path.to_s).to include 'data'
      expect(item.archival_path.to_s).to include 'archives'
    end 
  end

  context '.working_path' do
    it 'should return a pathname' do
      expect(item.working_path).to be_a Pathname  
    end 

    it 'should contain form_id' do
      expect(item.working_path.to_s).to include item.form_id.to_s
    end 

    it 'should contain uuid_path' do
      expect(item.working_path.to_s).to include item.uuid_path
    end 

    it 'should contain data/working' do
      expect(item.working_path.to_s).to include 'data'
      expect(item.working_path.to_s).to include 'working'
    end 
  end

  context '.conversion_path' do
    it 'should return a pathname' do
      expect(item.conversion_path).to be_a Pathname  
    end 

    it 'should contain form_id' do
      expect(item.conversion_path.to_s).to include item.form_id.to_s
    end 

    it 'should contain uuid_path' do
      expect(item.conversion_path.to_s).to include item.uuid_path
    end 

    it 'should contain data/conversions' do
      expect(item.conversion_path.to_s).to include 'data'
      expect(item.conversion_path.to_s).to include 'conversions'
    end 
  end
  
  context '.uuid_path' do
    it 'should return the uuid as a path' do
      path = item.uuid.gsub!('-', '/')
      expect(item.uuid_path).to eq path
    end
    
    it 'should be a string' do
      expect(item.uuid_path).to be_a String
    end 
  end

  context '.export_path' do
    it 'should return a pathname' do
      expect(item.export_path).to be_a Pathname  
    end 

    it 'should contain form_id' do
      expect(item.export_path.to_s).to include item.form_id.to_s
    end 

    it 'should contain uuid_path' do
      expect(item.export_path.to_s).to include item.uuid_path
    end 

    it 'should contain data/exports' do
      expect(item.export_path.to_s).to include 'data'
      expect(item.export_path.to_s).to include 'exports'
    end 
  end
  
end
