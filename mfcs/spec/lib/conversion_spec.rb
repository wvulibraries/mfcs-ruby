require 'rails_helper'

RSpec.describe Conversion do
  it "Should identify the mimetype as Audio" do
    expect(Conversion.determine_type("audio/wav")).to eq("Audio")
  end

  it "Should identify the mimetype as Video" do
    expect(Conversion.determine_type("video/mp4")).to eq("Video")
  end

  it "Should identify the mimetype as Image" do
    expect(Conversion.determine_type("image/jpeg")).to eq("Image")
  end
  
  it "Should identify the mimetype as Pdf" do
    expect(Conversion.determine_type("application/pdf")).to eq("Pdf")
  end
  
  it "Should identify the mimetype as Text" do
    expect(Conversion.determine_type("text/plain")).to eq("Text")
  end

  it "Should identify the mimetype as Other" do
    expect(Conversion.determine_type("application/octet-stream")).to eq("Other")
  end
end