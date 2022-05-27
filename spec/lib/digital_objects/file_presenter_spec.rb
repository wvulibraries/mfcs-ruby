require 'rails_helper'

RSpec.describe DigitalObjects::FilePresenter do
    let(:item) { FactoryBot.create(:complete_digital_object_user) } 
    let(:media) { FactoryBot.create(:audio) }
    # let(:working) { FactoryBot.create(:working_audio) }
    # let(:converted) { FactoryBot.create(:conversion_audio) }

    # setup file_info to mimic how it's passed into the presenter
    let(:file_info) do 
      file_info = {"id"=>media.id, "path"=>media.path, "size"=>media.size, "form_id"=>item.form_id, "item_id"=>item.id, "checksum"=>media.checksum, "filename"=>media.filename, "ocr_text"=>nil, "fieldname"=>"file_upload_audio", "mime_type"=>"audio/x-wav", "created_at"=>"2022-05-11T17:42:49.211Z", "media_type"=>"archive", "updated_at"=>"2022-05-11T17:42:49.211Z", "file_errors"=>nil, "soft_delete"=>false, "virus_scanned"=>nil}
    end 

    context '.initialize' do
        it 'has @file' do
          presenter = described_class.new(file_info)
          expect(presenter.instance_variable_defined?(:@file)).to be true
        end 

        it 'has @working' do
           presenter = described_class.new(file_info)
           expect(presenter.instance_variable_defined?(:@working)).to be true
        end  
        
        it 'has @item' do
           presenter = described_class.new(file_info)
           expect(presenter.instance_variable_defined?(:@item)).to be true
        end    
        
        it 'has @converted' do
           presenter = described_class.new(file_info)
           expect(presenter.instance_variable_defined?(:@converted)).to be true
        end

        it 'initalizes' do
            presenter = described_class.new(file_info)
            expect(presenter).to be_a described_class
        end

        it "returns the filename" do
            presenter = described_class.new(file_info)
            expect(presenter.filename).to eq(media.filename)
        end

        it "returns the converted filename" do
            presenter = described_class.new(file_info)
            expect(presenter.converted_filename).to eq("")
        end

        it "returns the archive_path" do
            presenter = described_class.new(file_info)
            expect(presenter.archive_path).to eq(media.path)
        end

        it "returns the checksum" do
            presenter = described_class.new(file_info)
            expect(presenter.checksum).to eq(media.checksum)
        end

        it "returns the size" do
            presenter = described_class.new(file_info)
            expect(presenter.size).to eq(media.size)
        end

        it "returns converted?" do
            presenter = described_class.new(file_info)
            expect(presenter.converted?).to eq(false)
        end

        # it "returns the location" do
        #     presenter = described_class.new(file_info)
        #     expect(presenter.location).to eq(media.path)
        # end

        it "returns the full_file_path" do
            presenter = described_class.new(file_info)
            expect(presenter.full_file_path).to eq(Rails.root.join("spec", "fixtures", "files").to_s + "/")
        end

        it "returns the converted_file_path" do
            presenter = described_class.new(file_info)
            expect(presenter.converted_file_path).to eq(item.conversion_path.to_s)
        end

        it "does not find any files in conversion folder" do  
            presenter = described_class.new(file_info)
            expect(presenter.converted_file_exists?).to be false
        end

        it "returns nil for file location since no file would be found" do
            presenter = described_class.new(file_info)
            expect(presenter.converted_file_location).to be nil
        end

        # it "return the thumbnail" do
        #     presenter = described_class.new(file_info)
        #     expect(presenter.thumbnail).to eq("/home/mfcs/data/114/2defbb0d/9f26/461b/a3c2/e134c60a09d6/thumbnails/4224.ParsonsAaron.AudioInt.11.9.16.jpg")
        # end

        # it "returns the preview_links" do
        #     presenter = described_class.new(file_info)
        #     expect(presenter.preview_links).to be truthy
        # end

        it "returns the fa_icon" do
            presenter = described_class.new(file_info)
            expect(presenter.fa_icon).to eq("fa fa-file-audio")
        end

        it "returns the field label" do
            presenter = described_class.new(file_info)
            expect(presenter.field_label).to eq("Converted Audio")
        end
    end    
end 