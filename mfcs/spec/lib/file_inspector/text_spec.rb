require 'rails_helper'

RSpec.describe FileInspector::Text, type: :model do
  data = JSON.parse(File.read(Rails.root.join("spec/fixtures/files/mimes_hash.json")))

  context '.matches?' do
    data['text'].sample(10).each do |mime| 
      it "#{mime} should pass the matcher." do
        expect(described_class.matches?(mime)).to be true
      end 
    end 

    data['audio'].sample(10).each do |mime| 
      it "#{mime} fails the matcher wrong file type" do
        expect(described_class.matches?(mime)).to be false
      end 
    end 
  end
end 