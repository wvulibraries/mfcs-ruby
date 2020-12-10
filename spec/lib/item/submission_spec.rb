require 'rails_helper'

RSpec.describe Submission::Stuff, type: :model do
  let(:file) { Rack::Test::UploadedFile.new(Rails.root.join("spec/fixtures/files/test_image_1.jpg")) }

  
  context 'test' do
    it 'has some behaviour' do
      puts file.inspect
      expect(true).to be false
    end
  end
  
end 