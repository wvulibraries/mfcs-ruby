require 'rails_helper'

RSpec.describe FieldBuilder::FileUploadField, type: :model do
  include RSpecHtmlMatchers

  let(:field_hash) do 
    field_hash = {"ocr"=>false, "name"=>"files", "type"=>"file", "label"=>"File Uploads", "value"=>"", "border"=>true, "css_id"=>"", "hidden"=>false, "combine"=>false, "convert"=>true, "disabled"=>false, "field_id"=>"19984943000040948", "help_url"=>"", "required"=>false, "sortable"=>false, "css_class"=>"", "help_info"=>"", "help_type"=>"", "read_only"=>false, "thumbnail"=>true, "watermark"=>true, "searchable"=>false, "sort_order"=>"6", "validation"=>"", "image_width"=>"800", "oai_release"=>false, "placeholder"=>"", "video_width"=>"1280", "audio_format"=>"mp3", "border_width"=>"", "image_format"=>"JPG", "image_height"=>"600", "local_styles"=>"", "video_format"=>"mp4", "video_height"=>"720", "audio_bitrate"=>"", "convert_audio"=>true, "convert_video"=>true, "no_duplicates"=>false, "video_bitrate"=>"", "multiple_files"=>true, "public_release"=>true, "display_in_list"=>false, "thumbnail_width"=>"200", "video_thumbnail"=>true, "watermark_image"=>"", "image_resolution"=>"120", "thumbnail_format"=>"JPG", "thumbnail_height"=>"200", "validation_regex"=>"", "allowed_file_types"=>"jpg,mp3,mov", "disabled_on_insert"=>false, "disabled_on_update"=>false, "metadata_standards"=>"", "watermark_location"=>"", "thumbnail_resolution"=>"90", "video_thumbnail_width"=>"200", "video_thumbnail_format"=>"JPG", "video_thumbnail_frames"=>"5", "video_thumbnail_height"=>"200"} 
  end 

  let(:user) {  FactoryBot.create(:user, :admin) }

  # shared examples
  context 'inherit parent behaviors without having to redo tests for all items' do
    it_behaves_like 'a field builder' 
  end

  context '.multiple_files' do
    it 'should return multiple as a string' do
      fb = described_class.new(field_hash, user, 'insert')
      expect(fb.multiple_files).to be_a String
      expect(fb.multiple_files).to eq 'multiple'
    end 

    it 'should not return a string should be nil' do
      field_hash['multiple_files'] = false
      fb = described_class.new(field_hash, user, 'insert')
      expect(fb.multiple_files).to be_nil
    end 
  end
  

  context '.html' do 
    it 'should have a multiple image files' do
      fb = described_class.new(field_hash, user, 'insert')
      expect(fb.html).to include 'multiple'
    end

    it 'should not have multiple images files' do
      field_hash['multiple_files'] = false
      fb = described_class.new(field_hash, user, 'insert')
      expect(fb.html).to_not include 'multiple'
    end

    it 'returns an html string' do
      fb = described_class.new(field_hash, user, 'insert')
      expect(fb.html).to be_a String
    end

    it 'expects the parent to be hidden' do
      field_hash['hidden'] = true
      fb = described_class.new(field_hash, user, 'insert')
      expect(fb.html).to be_a String
      expect(fb.html).to include 'hidden hide'
    end 

    it 'expects parent to be show' do
      field_hash['hidden'] = false
      fb = described_class.new(field_hash, user, 'insert')
      expect(fb.html).to be_a String
      expect(fb.html).to include 'show'
    end 

    it 'expects the html to contain the label' do
      fb = described_class.new(field_hash, user, 'insert')
      expect(fb.html).to be_a String
      expect(fb.html).to include fb.build_label
    end 
  end 
end