# == Schema Information
#
# Table name: watermarks
#
#  id         :bigint           not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
FactoryBot.define do
  factory :watermark do
    name { Faker::Movies::HitchhikersGuideToTheGalaxy.character }
    image { Rack::Test::UploadedFile.new('spec/fixtures/files/test_watermark.png', 'image/png') }
  end
end
