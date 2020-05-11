# == Schema Information
#
# Table name: watermarks
#
#  id         :bigint           not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
require 'rails_helper'

RSpec.describe Watermark, type: :model do
  # Factories 
  let(:watermark) { FactoryBot.create :watermark }
  
  # shared examples
  context 'shared examples' do
    it_behaves_like 'readonly'
    it_behaves_like 'a valid factory' # factorybot
  end
  
  # database fields
  context 'database fields' do
    context 'strings' do
      it { should have_db_column(:name).of_type(:string) }
    end
  end 

  # validations 
  context 'validations' do
    context 'Watermark.name' do
      it { should validate_presence_of(:name) }
      it { should validate_length_of(:name).is_at_least(1) }
      it { should validate_length_of(:name).is_at_most(250) }
    end
  end

  # images 
  context 'images' do
    context 'Watermark.image' do
      it 'has attached image' do
        watermark.image.attach(
          io: File.open(Rails.root.join('spec', 'fixtures', 'files', 'test_watermark.png')),
          filename: 'test_watermark.png',
          content_type: 'image/png'
        )
        expect(watermark.image).to be_attached
      end 
    end 
  end 
end
