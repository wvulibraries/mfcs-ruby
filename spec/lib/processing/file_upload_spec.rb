require 'rails_helper'

RSpec.describe Processing::FileUpload, type: :model do
  let(:file) { Rails.root.join("spec/fixtures/files/test_image_1.jpg") }

  let(:uploaded_file) { ActionDispatch::Http::UploadedFile.new(tempfile: file, filename: File.basename(file), type: "image/jpeg") }

  context '.intialize' do
    it 'initalizes' do
      base = described_class.new(1, uploaded_file)
      expect(base).to be_a described_class
    end
    
    it 'should have form instance var' do
      base = described_class.new(1, uploaded_file)
      expect(base.instance_variable_defined?(:@form_id)).to be true
    end
    
    it 'should have an uploaded uploaded_file instance var' do
      base = described_class.new(1, uploaded_file)
      expect(base.instance_variable_defined?(:@uploaded_file)).to be true
    end
  end
  
  context '.media' do
    it 'sets the proper instance var' do 
      base = described_class.new(1, uploaded_file)
      expect(base.media).to be_truthy
      expect(base.instance_variable_defined?(:@media)).to be true
    end

    it 'should return a class of Media' do
      base = described_class.new(1, uploaded_file)
      expect(base.media).to be_a Media
    end

    it 'expects media to have the same uuid and not generate a new class each time' do
      base = described_class.new(1, uploaded_file)
      expect(base.media.uuid).to eq(base.media.uuid)
    end 
  end 

  context '.create_path' do
    it 'creates a folder for given path' do
      base = described_class.new(1, uploaded_file)
      expect(base.create_path(Rails.root.join('tests', 'data', 'test_pass_youwill'))).to be_truthy 
    end 

    it 'does not create the path, it exists, but should still be truthy' do
      FileUtils.mkdir_p(Rails.root.join('tests', 'data', 'somethingdarkside'))
      base = described_class.new(1, uploaded_file)
      expect(base.create_path(Rails.root.join('tests', 'data', 'somethingdarkside'))).to be_truthy
    end 
  end 

  context '.save_file' do
    before(:each) do 
      @path = Rails.root.join('tests', 'data', 'somethingdarkside') 
      FileUtils.mkdir_p(@path) unless File.directory?(@path)
    end 

    it 'saves file given a file path' do
      base = described_class.new(1, uploaded_file)
      base.save_file(@path)
      expect(File.file?(@path.join(uploaded_file.original_filename))).to be true
    end 
  end 

  context '.set_versions' do
    before(:each) do 
      @base = described_class.new(1, uploaded_file)
      @base.set_versions 
    end 

    it 'set the working path and saves files' do
      working_file = @base.media.working_path.join(uploaded_file.original_filename)
      expect(File.file?(working_file)).to be true
    end 

    it 'set the archival path and saves files' do
      archive_file = @base.media.archival_path.join(uploaded_file.original_filename)
      expect(File.file?(archive_file)).to be true
    end 
  end 

  context '.save' do
    it 'should set the versions' do
      base = described_class.new(1, uploaded_file)
      archive_file = base.media.archival_path.join(uploaded_file.original_filename)
      working_file = base.media.working_path.join(uploaded_file.original_filename)
      base.save
      expect(File.file?(archive_file)).to be true
      expect(File.file?(working_file)).to be true
    end 

    it 'should return true the media objects should save' do
      base = described_class.new(1, uploaded_file)
      expect(base.save).to be_truthy
      expect(base.save).to be_a String
    end
  end 
end 
