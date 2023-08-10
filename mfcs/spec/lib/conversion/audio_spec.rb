require 'rails_helper'

RSpec.describe Conversion::Audio do 
  let(:form) { FactoryBot.build_stubbed(:file_conversion_form) }
  let(:stubbed_media) { FactoryBot.build_stubbed(:media) }
  let(:media) { FactoryBot.create(:audio) }

  data = JSON.parse(File.read(Rails.root.join("spec/fixtures/files/mimes_hash.json")))

  context '.matches?' do
    data['audio'].sample(10).each do |mime| 
      it "#{mime} should pass the matcher." do
        expect(described_class.matches?(mime)).to be true
      end 
    end 

    data['application'].sample(10).each do |mime| 
      it "#{mime} fails the matcher wrong file type" do
        expect(described_class.matches?(mime)).to be false
      end 
    end 
  end

  context '.initialize' do
    it 'has @media' do
      params_hash = form.organized_hash[:files]
      base = described_class.new(media.id, params_hash)
      expect(base.instance_variable_defined?(:@media)).to be true
    end 

    it 'has @conversion_params' do 
      params_hash = form.organized_hash[:files]
      base = described_class.new(media.id, params_hash)
      expect(base.instance_variable_defined?(:@conversion_params)).to be true
    end 
  end

  context '.save_file' do
    it 'should create a saveable file path with format and filename' do
      params_hash = form.organized_hash[:files]
      base = described_class.new(media.id, params_hash)
      expect(base.save_file).to be_a Pathname
    end 

    it 'should end as a ogg' do
      params_hash = form.organized_hash[:files]
      params_hash['audio_format'] = 'ogg'
      base = described_class.new(media.id, params_hash)
      expect(base.save_file.basename.to_s).to  eq 'storm.ogg'
    end 

    it 'should create a mp3 if no format is given' do
      params_hash = form.organized_hash[:files]
      params_hash['audio_format'] = nil
      base = described_class.new(media.id, params_hash)
      expect(base.save_file.basename.to_s).to  eq 'storm.mp3'
    end

  end 

  context '.perform' do
    it 'should create a mp3' do
      params_hash = form.organized_hash[:files]
      params_hash['audio_format'] = 'mp3'
      params_hash['audio_bitrate'] = '12k'
      base = described_class.new(media.id, params_hash)
      expect(base.perform).to be_truthy
    end
  end
end 