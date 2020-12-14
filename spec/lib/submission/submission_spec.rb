require 'rails_helper'

RSpec.describe Submission::Stuff, type: :model do
  let(:file) { Rack::Test::UploadedFile.new(Rails.root.join("spec/fixtures/files/test_image_1.jpg")) }

  let(:post) { 
    {
      utf8: "✓",
      authenticity_token: "test_token",
      item: {
        form_id: "14",
        metadata: "false",
        public_release: "true",
        data: {
          idno: "asdf",
          title: "asdfsafa",
          UntitledNumberField: "11",
          files: [file]
        }
      }
    }
  }
  
  it 'should pull the file content out of the params'
  it 'should pull the metadata content out of the params'
  
  
end 