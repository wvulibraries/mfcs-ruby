require 'rails_helper'

RSpec.describe Processing::FileUpload, type: :model do
  let(:item) { FactoryBot.create(:complete_digital_object_user) } 
  let(:file) { Rails.root.join("spec/fixtures/files/test_image_1.jpg") } 
  let(:uploaded_file) { ActionDispatch::Http::UploadedFile.new(tempfile: file, filename: File.basename(file), type: "image/jpeg") }

  context '.intialize' do
    it 'initalizes' do
      base = described_class.new(item.id, uploaded_file, 'fieldname')
      expect(base).to be_a described_class
    end

    it 'should have item instance var' do
      base = described_class.new(item.id, uploaded_file, 'fieldname')
      expect(base.instance_variable_defined?(:@item)).to be true
    end

    it 'should have a uploaded_file instance var' do
      base = described_class.new(item.id, uploaded_file, 'fieldname')
      expect(base.instance_variable_defined?(:@uploaded_file)).to be true
    end

    it 'should have a directories instance var' do
      base = described_class.new(item.id, uploaded_file, 'fieldname')
      expect(base.instance_variable_defined?(:@directories)).to be true
    end         
  end
  
  context '.archive_media' do
    it 'sets the proper instance var' do 
      base = described_class.new(item.id, uploaded_file, 'fieldname')
      expect(base.archive_media).to be_truthy
      expect(base.instance_variable_defined?(:@archive_media)).to be true
    end

    it 'should return a class of Media' do
      base = described_class.new(item.id, uploaded_file, 'fieldname')
      expect(base.archive_media).to be_a Media
    end
  end 

  context '.working_media' do
    it 'sets the proper instance var' do 
      base = described_class.new(item.id, uploaded_file, 'fieldname')
      expect(base.working_media).to be_truthy
      expect(base.instance_variable_defined?(:@working_media)).to be true
    end

    it 'should return a class of Media' do
      base = described_class.new(item.id, uploaded_file, 'fieldname')
      expect(base.working_media).to be_a Media
    end
  end 

  context '.save_file' do
    before(:each) do 
      @path = Rails.root.join('tests', 'data', 'somethingdarkside') 
      FileUtils.mkdir_p(@path) unless File.directory?(@path)
    end 

    it 'saves file given a file path' do
      base = described_class.new(item.id, uploaded_file, 'fieldname')
      base.save_file(@path)
      expect(File.file?(@path.join(uploaded_file.original_filename))).to be true
    end 
  end 

  context '.set_versions' do
    before(:each) do 
      @base = described_class.new(item.id, uploaded_file, 'fieldname')
      @base.set_versions 
    end 

    it 'set the working path and saves files' do
      working_file = @base.working_path.join(uploaded_file.original_filename)
      expect(File.file?(working_file)).to be true
    end 

    it 'set the archival path and saves files' do
      archive_file = @base.archival_path.join(uploaded_file.original_filename)
      expect(File.file?(archive_file)).to be true
    end 
  end 

  context '.save' do
    it 'should set the versions' do
      base = described_class.new(item.id, uploaded_file, 'fieldname')
      archive_file = base.archival_path.join(uploaded_file.original_filename)
      working_file = base.working_path.join(uploaded_file.original_filename)
      base.save
      expect(File.file?(archive_file)).to be true
      expect(File.file?(working_file)).to be true
    end 

    it 'should return true the media objects should save' do
      base = described_class.new(item.id, uploaded_file, 'fieldname')
      expect(base.save).to be_truthy
    end
  end 
end 
