# == Schema Information
#
# Table name: forms
#
#  id                            :bigint           not null, primary key
#  container                     :boolean          default(FALSE), not null
#  count                         :integer
#  description                   :text
#  display_title                 :string
#  export_oai                    :boolean          default(FALSE), not null
#  export_public                 :boolean          default(FALSE), not null
#  fields                        :jsonb            is an Array
#  idno                          :jsonb
#  link_title                    :string
#  metadata                      :boolean          default(FALSE), not null
#  navigation                    :jsonb            is an Array
#  object_public_release_default :boolean          default(FALSE), not null
#  object_public_release_show    :boolean          default(FALSE), not null
#  object_title_field            :string
#  permissions                   :jsonb            is an Array
#  production                    :boolean          default(FALSE), not null
#  submit_button                 :string
#  title                         :string
#  update_button                 :string
#  created_at                    :datetime         not null
#  updated_at                    :datetime         not null
#
# Indexes
#
#  index_forms_on_idno  (idno)
#
require 'rails_helper'
require 'json'

RSpec.describe Form, type: :model do
  # shared examples
  context 'shared examples' do
    it_behaves_like 'readonly'
    it_behaves_like 'a valid factory' # factorybot
  end

  # database fields
  context 'database fields' do
    context 'strings' do
      it { should have_db_column(:title).of_type(:string) }
      it { should have_db_column(:description).of_type(:text) }
      it { should have_db_column(:submit_button).of_type(:string) }
      it { should have_db_column(:update_button).of_type(:string) }
      it { should have_db_column(:display_title).of_type(:string) }
      it { should have_db_column(:object_title_field).of_type(:string) }
      it { should have_db_column(:link_title).of_type(:string) }
    end

    context 'booleans' do
      it { should have_db_column(:production).of_type(:boolean) }
      it { should have_db_column(:container).of_type(:boolean) }
      it { should have_db_column(:metadata).of_type(:boolean) }
      it { should have_db_column(:export_public).of_type(:boolean) }
      it { should have_db_column(:export_oai).of_type(:boolean) }
      it { should have_db_column(:object_public_release_default).of_type(:boolean) }
      it { should have_db_column(:object_public_release_show).of_type(:boolean) }
    end

    context 'integers' do
      it { should have_db_column(:count).of_type(:integer) }
    end

    context 'datestamps' do
      it { should have_db_column(:created_at).of_type(:datetime) }
      it { should have_db_column(:updated_at).of_type(:datetime) }
    end

    context 'jsonb' do
      it { should have_db_column(:navigation).of_type(:jsonb) }
      it { should have_db_column(:fields).of_type(:jsonb) }
      it { should have_db_column(:permissions).of_type(:jsonb) }
      it { should have_db_column(:idno).of_type(:jsonb) }
    end
  end

  # validations
  context 'validations' do
    context 'Form.title' do
      it { should validate_presence_of(:title) }
      it { should validate_length_of(:title).is_at_least(1) }
      it { should validate_length_of(:title).is_at_most(250) }
      it { should validate_uniqueness_of(:title) }
    end

    context 'Form.display_title' do
      it { should validate_presence_of(:display_title) }
      it { should validate_length_of(:display_title).is_at_least(1) }
      it { should validate_length_of(:display_title).is_at_most(250) }
      it { should validate_uniqueness_of(:display_title) }
    end
  end

  # permissions association
  context 'permissions' do
    context 'associations' do
      it { should have_many(:permissions) }
      it { should have_many(:viewers) }
      it { should have_many(:admins) }
      it { should have_many(:contacts) }
      it { should have_many(:creators) }
      it { should have_many(:items) }
    end 

    context 'viewers test' do
      it 'valid permission test' do
        form = FactoryBot.create(:form)
        user = FactoryBot.create(:user, :basic) 
        permission = Permission.create(user: user, form: form, permission: :viewer)
        expect(permission).to be_valid
        expect(permission.user).to be_a User
      end 

      it 'should create some viewers and an admin' do
        form = FactoryBot.create(:form)
        user = FactoryBot.create(:user, :basic) 
        user1 = FactoryBot.create(:user, :admin)
        user2 = FactoryBot.create(:user, :editor)
        
        Permission.create(user: user, form: form, permission: :viewer)
        Permission.create(user: user1, form: form, permission: :viewer)
        Permission.create(user: user2, form: form, permission: :admin)

        expect(form.viewers.count).to eq 2
        expect(form.admins.count).to eq 1
      end 


      it 'should create some of every enum type and give some users duplicates of each' do
        form = FactoryBot.create(:form)
        user = FactoryBot.create(:user, :basic) 
        user1 = FactoryBot.create(:user, :admin)
        user2 = FactoryBot.create(:user, :editor)
        user3 = FactoryBot.create(:user, :basic) 
        user4 = FactoryBot.create(:user, :admin)
        user5 = FactoryBot.create(:user, :editor)
        
        Permission.create(user: user, form: form, permission: :viewer)
        Permission.create(user: user1, form: form, permission: :viewer)
        Permission.create(user: user5, form: form, permission: :viewer)
        Permission.create(user: user2, form: form, permission: :admin)
        Permission.create(user: user3, form: form, permission: :admin)
        Permission.create(user: user4, form: form, permission: :creator)
        Permission.create(user: user5, form: form, permission: :creator)
        Permission.create(user: user1, form: form, permission: :creator)

        Permission.create(user: user, form: form, permission: :contact)
        Permission.create(user: user1, form: form, permission: :contact)
        Permission.create(user: user2, form: form, permission: :contact)
        Permission.create(user: user3, form: form, permission: :contact)
        Permission.create(user: user4, form: form, permission: :contact)
        Permission.create(user: user5, form: form, permission: :contact)

        expect(form.viewers.count).to eq 3
        expect(form.admins.count).to eq 2
        expect(form.creators.count).to eq 3 
        expect(form.contacts.count).to eq 6
      end 
    end 
  end 

  # set defaults
  context 'defaults' do
    it 'should init and set default values' do
      form = Form.new # init
      expect(form.submit_button).to eq('Submit')
      expect(form.update_button).to eq('Update')
      expect(form.container).to be false
      expect(form.production).to be true
      expect(form.export_public).to be true
      expect(form.export_oai).to be true
    end
  end

  # settings some json field data 
  context 'imported data' do
    it 'valid json production data that will save in the database' do
      f = FactoryBot.build(:form)
      f.fields = JSON.parse(file_fixture('pec.json').read)
      expect(f.valid?).to be true
      expect(f.save).to be true
    end
  end

  context '.linked_forms' do
    it 'expects empty array for non-hash items' do
      data = FactoryBot.build(:form)
      expect(data.linked_forms).to be_a Array
    end

    it 'expects empty array for items without links' do
      data = FactoryBot.build(:form)
      data.fields = [{ item: 'testing', idno: '192848;dflkjadsf' }] 
      expect(data.linked_forms).to be_a Array
      expect(data.linked_forms).to eq []
    end

    it 'expects an array of integers from productions style data' do
      f = FactoryBot.build(:form)
      f.fields = JSON.parse(file_fixture('pec.json').read)
      expect(f.linked_forms).to eq([1, 3, 4, 5, 6, 9, 10, 11, 12, 13, 14])
    end
  end

  context '.fields' do
    it 'expects the data to be a json string unless blank or nil' do
      data = FactoryBot.build(:form)
      expect(data.fields).to be nil
    end 

    it 'expects that json to be a string' do
      f = FactoryBot.build(:form)
      f.fields = JSON.parse(file_fixture('pec.json').read)
      expect(f.fields).to be_a String
    end 
  end 

  context 'scopes' do
    context '.object_forms' do
      it 'expects it to include the form' do
        data = FactoryBot.build(:form)
        data.metadata = false
        data.save 
        expect(Form.object_forms).to include(data)
      end 

      it 'expects it to include the form' do
        data = FactoryBot.build(:form)
        data.metadata = true
        data.save 
        expect(Form.object_forms).to_not include(data)
      end
    end

    context '.metadata_forms' do
      it 'expects it to include the form' do
        data = FactoryBot.build(:form)
        data.metadata = true
        data.save 
        expect(Form.metadata_forms).to include(data)
      end 

      it 'expects it to include the form' do
        data = FactoryBot.build(:form)
        data.metadata = false
        data.save 
        expect(Form.metadata_forms).to_not include(data)
      end
    end
  end

  context 'audits' do
    it 'Should respond to audit methods' do
      form = FactoryBot.build(:form)
      form.metadata = false
      form.save 
      expect(form.respond_to?(:audits)).to be true
    end

    it 'should have a few audits' do
      form = FactoryBot.build(:form)
      form.metadata = false
      form.save 
      form.update(metadata: true)
      form.update(title: 'Another Title') 
      expect(form.respond_to?(:audits)).to be true
      expect(form.audits.count).to eq 2
    end 
  end 

  context '.fields' do
    it 'should return nil if there is nothing there' do
      data = FactoryBot.build(:form)
      expect(data.fields).to be_nil
    end 

    it 'should return a json string if there is data that exists' do
      data = FactoryBot.build(:form)
      data.fields = [{ item: 'testing', idno: '192848;dflkjadsf' }] 
      expect(data.fields).to be_a String
    end 
  end
  
  context '.fields_hash' do
    it 'should return nil if there is nothing there' do
      data = FactoryBot.build(:form)
      expect(data.fields_hash).to be_a Array
    end 

    it 'should return a json string if there is data that exists' do
      data = FactoryBot.build(:form)
      data.fields = [{ item: 'testing', idno: '192848;dflkjadsf' }] 
      expect(data.fields_hash).to be_a Array
    end 
  end 

  context '.organized_hash' do
    it 'it will be a hash still even if no data exists' do
      data = FactoryBot.build(:form)
      expect(data.organized_hash).to be_a Hash
    end 

    it 'should have a key of 0 because no name exists' do 
      data = FactoryBot.build(:form)
      data.fields = [{ item: 'testing', idno: '192848;dflkjadsf' }] 
      expect(data.organized_hash).to be_a Hash
      expect(data.organized_hash).to have_key(0)
    end 

    it 'should have a key with a name because the name exists' do
      data = FactoryBot.build(:form)
      data.fields = [{ item: 'testing', idno: '192848;dflkjadsf', name:'identifier' }] 
      expect(data.organized_hash).to be_a Hash
      expect(data.organized_hash).to have_key('identifier')
    end 
  end 

  context '.associated_metadata_forms' do
    it 'expects the choice form to exist and contain one number as a set' do
      data = FactoryBot.build(:form)
      data.fields = [{"name"=>"dropdown", "type"=>"select", "label"=>"A dropdown menu", "value"=>"", "css_id"=>"", "hidden"=>false, "choices"=>"Awesome", "disabled"=>false, "field_id"=>"10518135000020266", "help_url"=>"", "required"=>false, "sortable"=>false, "css_class"=>"", "help_info"=>"", "help_type"=>"", "read_only"=>false, "searchable"=>false, "sort_order"=>"4", "validation"=>"", "choice_form"=>"11", "choice_null"=>true, "choice_type"=>"link_to_form", "oai_release"=>false, "placeholder"=>"", "choice_array"=>"", "local_styles"=>"", "no_duplicates"=>false, "default_choice"=>"", "public_release"=>true, "display_in_list"=>false, "validation_regex"=>"", "choice_form_field"=>"title", "disabled_on_insert"=>false, "disabled_on_update"=>false, "metadata_standards"=>[{"schema"=>"Dublin Core", "identifier"=>"idea", "qualifier"=>"magnets"}, {"schema"=>"Dublin Core", "identifier"=>"usage", "qualifier"=>"rightsStatement"}]}]
      data.save! 
      
      expect(data.associated_metadata_forms).to be_a Set
      expect(data.associated_metadata_forms).to include '11'
    end
   
    it 'expects to be empty' do
      data = FactoryBot.build(:form)
      data.fields = [{"name"=>"dropdown", "type"=>"select", "label"=>"A dropdown menu", "value"=>"", "css_id"=>"", "hidden"=>false, "choices"=>"Awesome", "disabled"=>false, "field_id"=>"10518135000020266", "help_url"=>"", "required"=>false, "sortable"=>false, "css_class"=>"", "help_info"=>"", "help_type"=>"", "read_only"=>false, "searchable"=>false, "sort_order"=>"4", "validation"=>"", "choice_form"=>"", "choice_null"=>true, "choice_type"=>"manual", "oai_release"=>false, "placeholder"=>"", "choice_array"=>"Testing,Something Really Cool,Awesome", "local_styles"=>"", "no_duplicates"=>false, "default_choice"=>"", "public_release"=>true, "display_in_list"=>false, "validation_regex"=>"", "choice_form_field"=>"", "disabled_on_insert"=>false, "disabled_on_update"=>false, "metadata_standards"=>[{"schema"=>"Dublin Core", "identifier"=>"idea", "qualifier"=>"magnets"}, {"schema"=>"Dublin Core", "identifier"=>"usage", "qualifier"=>"rightsStatement"}]}]
      data.save! 

      expect(data.associated_metadata_forms).to be_a Set
      expect(data.associated_metadata_forms.count).to eq 0
    end
  end 

  context '.check_duplicates' do
    it 'should return an empty set for no data' do
      data = FactoryBot.build(:form)
      expect(data.check_duplicates).to be_a Set
      expect(data.check_duplicates.count).to eq 0
    end

    it 'should return a set of field names' do
      data = FactoryBot.build(:form)
      data.fields = JSON.parse(file_fixture('pec.json').read)
      expect(data.check_duplicates.count).to eq 1
      expect(data.check_duplicates).to be_a Set
    end
  end 

  context '.check_validations' do
    it 'should return an empty set for no data' do
      data = FactoryBot.build(:form)
      expect(data.check_validations).to be_a Set
      expect(data.check_validations.count).to eq 0
    end

    it 'should return a set of field names' do
      data = FactoryBot.build(:form)
      data.fields = JSON.parse(file_fixture('pec.json').read)
      expect(data.check_validations.count).to eq 1
      expect(data.check_validations).to be_a Set
    end
  end

  context '.file_fields' do
    it 'should return an empty set for no data' do
      data = FactoryBot.build(:form)
      expect(data.file_fields).to be_a Set
      expect(data.file_fields.count).to eq 0
    end

    it 'should return a set of field names' do
      data = FactoryBot.build(:form)
      data.fields = JSON.parse(file_fixture('pec.json').read)
      expect(data.file_fields.count).to eq 1
      expect(data.file_fields).to be_a Set
    end
  end
  
end
