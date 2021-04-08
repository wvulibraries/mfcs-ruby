# == Schema Information
#
# Table name: media
#
#  id            :bigint           not null, primary key
#  checksum      :string
#  fieldname     :string
#  file_errors   :jsonb
#  filename      :string
#  media_type    :integer
#  mime_type     :string
#  path          :string
#  size          :string
#  virus_scanned :boolean
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  form_id       :integer
#  item_id       :integer
#
FactoryBot.define do
  factory :media do

    before(:create) do |media|
      item = FactoryBot.create(:item_with_file)
      media.form_id = item.form.id 
      media.item_id  = item.id
    end

    filename { 'test_image_1.jpg' }
    path { Rails.root.join('spec','fixtures', 'files', 'test_image_1.jpg') }
    size { nil }
    checksum { nil }
    file_errors { nil }
    virus_scanned { false}
    mime_type { nil }
    media_type { 0 }
    fieldname { 'files' }

    factory :audio do
      filename { 'storm.wav' }
      path { Rails.root.join('spec','fixtures', 'files', 'storm.wav') }
    end 

    factory :video do
      filename { 'test.mov' }
      path { Rails.root.join('spec','fixtures', 'files', 'test.mov') }
    end 
  end
end
