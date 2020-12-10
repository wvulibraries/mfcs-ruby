# == Schema Information
#
# Table name: media
#
#  id            :bigint           not null, primary key
#  checksum      :string
#  file_errors   :jsonb
#  filename      :string
#  mime_type     :string
#  path          :string
#  size          :string
#  uuid          :string
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
    it { should have_db_column(:mime_type).of_type(:string) }
    it { should have_db_column(:path).of_type(:string) }
    it { should have_db_column(:size).of_type(:string) }
    it { should have_db_column(:uuid).of_type(:string) }
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
    it { should validate_presence_of(:item_id) }
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

  # UUID
  # ================================================================
  context 'Default UUID' do
    it 'expects the uuid to be generated' do
      expect(media.uuid).to be_a String
    end 

    it 'exepects the uuid to be 36 characters' do
      expect(media.uuid.length).to eq 36
    end 

    it 'expects uuid to stay the same after a save' do
      uuid = media.uuid
      media.filename = 'testing.txt'
      media.save!
      expect(media.uuid).to eq uuid  
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

  # File Paths
  # ===============================================================
  context '.archival_path' do
    it 'should return a pathname' do
      expect(media.archival_path).to be_a Pathname  
    end 

    it 'should contain form_id' do
      expect(media.archival_path.to_s).to include media.form_id.to_s
    end 

    it 'should contain uuid_path' do
      expect(media.archival_path.to_s).to include media.uuid_path
    end 

    it 'should contain data/archives' do
      expect(media.archival_path.to_s).to include 'data'
      expect(media.archival_path.to_s).to include 'archives'
    end 
  end

  context '.working_path' do
    it 'should return a pathname' do
      expect(media.working_path).to be_a Pathname  
    end 

    it 'should contain form_id' do
      expect(media.working_path.to_s).to include media.form_id.to_s
    end 

    it 'should contain uuid_path' do
      puts media.working_path.inspect
      puts media.uuid.inspect
      expect(media.working_path.to_s).to include media.uuid_path
    end 

    it 'should contain data/working' do
      expect(media.working_path.to_s).to include 'data'
      expect(media.working_path.to_s).to include 'working'
    end 
  end

  context '.conversion_path' do
    it 'should return a pathname' do
      expect(media.conversion_path).to be_a Pathname  
    end 

    it 'should contain form_id' do
      expect(media.conversion_path.to_s).to include media.form_id.to_s
    end 

    it 'should contain uuid_path' do
      expect(media.conversion_path.to_s).to include media.uuid_path
    end 

    it 'should contain data/conversions' do
      expect(media.conversion_path.to_s).to include 'data'
      expect(media.conversion_path.to_s).to include 'conversions'
    end 
  end
  
  context '.uuid_path' do
    it 'should return the uuid as a path' do
      path = media.uuid.gsub!('-', '/')
      expect(media.uuid_path).to eq path
    end
    
    it 'should be a string' do
      expect(media.uuid_path).to be_a String
    end 
  end

  context '.export_path' do
    it 'should return a pathname' do
      expect(media.export_path).to be_a Pathname  
    end 

    it 'should contain form_id' do
      expect(media.export_path.to_s).to include media.form_id.to_s
    end 

    it 'should contain uuid_path' do
      expect(media.export_path.to_s).to include media.uuid_path
    end 

    it 'should contain data/exports' do
      expect(media.export_path.to_s).to include 'data'
      expect(media.export_path.to_s).to include 'exports'
    end 
  end

  context '.as_json' do
    it 'should return a json string' do
      puts media.as_json.inspect
      expect(media.as_json).to be false
    end
  end 

end
