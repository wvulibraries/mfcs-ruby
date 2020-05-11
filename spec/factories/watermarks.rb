FactoryBot.define do
  factory :watermark do
    name { Faker::Movies::HitchhikersGuideToTheGalaxy.character }
    image { Rack::Test::UploadedFile.new('spec/fixtures/files/test_watermark.png', 'image/png') }
  end
end
