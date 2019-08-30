require 'rails_helper'

RSpec.describe FileField, type: :model do
  let(:file) { FileField.new }

  context 'shared tests' do
    it_behaves_like 'a field'
    it_behaves_like 'fieldable'
    it_behaves_like 'readonly'
    it_behaves_like 'a valid factory' # factorybot
  end

  context 'array options for file field' do
    it { should have_db_column(:extensions).of_type(:string) }
    it { should have_db_column(:image_options).of_type(:string) }
    it { should have_db_column(:audio_options).of_type(:string) }
    it { should have_db_column(:video_options).of_type(:string) }
  end

  context 'thumbnail database fields' do
    it { should have_db_column(:thumbnail_format).of_type(:string) }
    it { should have_db_column(:thumbnail_height).of_type(:integer) }
    it { should have_db_column(:thumbnail_width).of_type(:integer) }
  end

  context 'image conversion fields' do
    it { should have_db_column(:img_height).of_type(:integer) }
    it { should have_db_column(:img_width).of_type(:integer) }
    it { should have_db_column(:img_format).of_type(:string) }
    it { should have_db_column(:img_dpi).of_type(:integer) }
    it { should have_db_column(:img_watermark).of_type(:boolean) }
    it { should have_db_column(:img_border).of_type(:boolean) }
  end

  context 'border options' do
    it { should have_db_column(:border_color).of_type(:string) }
    it { should have_db_column(:border_width).of_type(:integer) }
    it { should have_db_column(:border_height).of_type(:integer) }
  end 

  context 'watermark options' do
    it { should have_db_column(:watermark_img).of_type(:integer) }
    it { should have_db_column(:watermark_location).of_type(:string) }
  end

  context 'audio conversions' do
    it { should have_db_column(:audio_bitrate).of_type(:integer) }
    it { should have_db_column(:audio_format).of_type(:string) }
  end

  context 'video conversions' do
    it { should have_db_column(:video_bitrate).of_type(:integer) }
    it { should have_db_column(:video_format).of_type(:string) }
  end

  context 'defaults' do
    it 'public_release should be true' do
      expect(file.public_release).to be true
    end

    it 'name should be untitled' do
      expect(file.name).to be_a(String)
      expect(file.name.downcase).to eq 'untitled'
    end

    it 'label should be untitled' do
      expect(file.label).to be_a(String)
      expect(file.label.downcase).to eq 'untitled'
    end

    it 'sets types to integer' do
      expect(file.type).to be_a(String)
      expect(file.type.downcase).to eq 'file'
    end
  end
end
