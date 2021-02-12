# == Schema Information
#
# Table name: items
#
#  id             :bigint           not null, primary key
#  data           :jsonb
#  idno           :string
#  metadata       :boolean
#  public_release :boolean
#  uuid           :string
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  form_id        :integer
#
FactoryBot.define do
  factory :item do
    idno = Faker::Internet.unique.uuid 

    updated_at { DateTime.now }
    created_at { DateTime.now }
    public_release { Faker::Boolean.boolean }

    factory :metadata do
      data { {"title" => "#{Faker::Movies::LordOfTheRings.character}"} }
      metadata { true }
      idno { nil }   
      association :form, factory: :metadata_form
    end 

    factory :item_object do
      data { "{'title': '#{Faker::Movies::LordOfTheRings.character}', 'idno':'#{idno}'}" }
      metadata { false }
      idno { }
      public_release { Faker::Boolean.boolean }
      association :form, factory: :object_form
    end 

    factory :complete_digital_object_system do 
      data {  
        { 
          email: 'gmail@test.com', 
          title: 'testing'
        }
      }
      metadata { false }
      idno { }
      public_release { Faker::Boolean.boolean }
      association :form, factory: :complete_object_form_system
    end

    factory :item_with_file do 
      data {  
        { 
          idno: 'sweet_idno_number_user_gen',
          title: 'testing'
        }
      }
      metadata { false }
      idno {'sweet_idno_number_user_gen' }
      public_release { Faker::Boolean.boolean }
      association :form, factory: :file_conversion_form
    end 

    factory :complete_digital_object_user do 
      data { 
        { idno: 'sweet_idno_number_user_gen',
          email: 'gmail@test.com',
          title: 'testing'
        } 
      }
      metadata { false }
      idno { }
      public_release { Faker::Boolean.boolean }
      association :form, factory: :complete_object_form_user
    end
    
    factory :complete_metadata_object do
      data { "{\"title\"=>\"asdf\"}" }
      metadata { true }
      idno { }
      public_release { Faker::Boolean.boolean }
      association :form, factory: :complete_metadata_form
    end 
  end
end
