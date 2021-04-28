# == Schema Information
#
# Table name: media
#
#  id            :bigint           not null, primary key
#  checksum      :string
#  fieldname     :string
#  file_errors   :jsonb
#  filename      :string
#  media_type    :integer
#  mime_type     :string
#  ocr_text      :text
#  path          :string
#  size          :string
#  virus_scanned :boolean
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  form_id       :integer
#  item_id       :integer
#
require 'rails_helper'

RSpec.describe Media, type: :model do
  let(:media) { FactoryBot.create :media }

  # Database Columns 
  # ================================================================
  context 'database columns' do
    it { should have_db_column(:id).of_type(:integer) }
    it { should have_db_column(:checksum).of_type(:string) }
    it { should have_db_column(:file_errors).of_type(:jsonb) }
    it { should have_db_column(:filename).of_type(:string) }
    it { should have_db_column(:media_type).of_type(:integer) }
    it { should have_db_column(:mime_type).of_type(:string) }
    it { should have_db_column(:path).of_type(:string) }
    it { should have_db_column(:size).of_type(:string) }
    it { should have_db_column(:virus_scanned).of_type(:boolean) }
    it { should have_db_column(:created_at).of_type(:datetime) }
    it { should have_db_column(:updated_at).of_type(:datetime) }
    it { should have_db_column(:form_id).of_type(:integer) }
    it { should have_db_column(:item_id).of_type(:integer) }
  end

  # Validations 
  # ================================================================
  context 'validations' do
    it { should validate_presence_of(:filename) }
    it { should validate_presence_of(:path) }
    it { should validate_presence_of(:form_id) }
  end

  context '.file_info' do
    it "triggers file_info before save" do
      item = FactoryBot.create(:complete_digital_object_user)
      m = FactoryBot.build :media
      m.item_id = item.id 
      m.form_id = item.form.id
      expect(m).to receive(:file_info)
      m.save
    end
    
    it "should set mime, checksum, size in the media object" do
      item = FactoryBot.create(:complete_digital_object_user)
      m = FactoryBot.build :media
      m.item_id = item.id 
      m.form_id = item.form.id

      expect(m.mime_type).to be_nil 
      expect(m.size).to be_nil 
      expect(m.checksum).to be_nil 
      
      m.save

      expect(m.mime_type).to be_truthy
      expect(m.size).to be_truthy
      expect(m.checksum).to be_truthy 
    end
  end 

  # Factory Test
  # ================================================================
  context 'Factory Test' do
    it 'should be a valid factory' do
      expect(media.valid?).to be true
    end
  end
  
  
  # Filesize
  # ================================================================
  context '.filesize' do
    it 'should return a String' do
      file = Rails.root.join('spec','fixtures', 'files', 'test_image_1.jpg')
      expect(media.filesize(file)).to be_a String
    end 

    it 'should include number in KB' do
      file = Rails.root.join('spec','fixtures', 'files', 'test_image_1.jpg')
      expect(media.filesize(file)).to include "KB"
    end 
  end
  
  # MimeType
  # ================================================================
  context '.mime' do
    it 'should return image/jpg for the mime of the file' do
      file = Rails.root.join('spec','fixtures', 'files', 'test_image_1.jpg')
      expect(media.mime(file)).to eq 'image/jpeg'
    end 

    it 'should return image/jpg for the mime even though file says swf' do
      file = Rails.root.join('spec','fixtures', 'files', 'false_mime.swf')
      expect(media.mime(file)).to eq 'image/jpeg'
    end 
  end

  
  # Checksum
  # ===============================================================
  context '.generate_checksum' do
    it 'generates a checksum for the file contents' do
      file = Rails.root.join('spec','fixtures', 'files', 'test_image_1.jpg')
      expect(media.generate_checksum(file)).to eq(Digest::MD5.hexdigest(File.read(file)))
      expect(media.generate_checksum(file)).to be_a String
    end 

    it 'expects file 1 to be the same as file 2 because they are the same with different names' do
      file1 = Rails.root.join('spec','fixtures', 'files', 'test_image_1.jpg')
      file2 = Rails.root.join('spec','fixtures', 'files', 'test_image_2.jpg')
      expect(media.generate_checksum(file1)).to eq(media.generate_checksum(file2))
    end 

    it 'ensures different files are different checksums' do
      file1 = Rails.root.join('spec','fixtures', 'files', 'test_image_1.jpg')
      file2 = Rails.root.join('spec','fixtures', 'files', 'test_image_3.jpg')
      expect(media.generate_checksum(file1)).to_not eq(media.generate_checksum(file2))
    end 

    it 'returns a nil or false value for non existant filepaths' do
      file = Rails.root.join('spec','fixtures', 'files', 'failing_non_file.jpg')
      expect(media.generate_checksum(file)).to be false
    end 
  end
  
  # # As Json
  # # ===============================================================
  context '.json' do
    it 'should return a json string' do
      expect(media.json).to be_a String
    end
  end 

  # Info
  # ===============================================================
  context '.info' do
    it 'should return a json string' do
      expect(media.info).to be_a Hash
    end
  end 

end
