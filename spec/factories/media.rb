# == Schema Information
#
# Table name: media
#
#  id            :bigint           not null, primary key
#  checksum      :string
#  file_errors   :jsonb
#  filename      :string
#  mime_type     :string
#  path          :string
#  size          :string
#  uuid          :string
#  virus_scanned :boolean
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  form_id       :integer
#  item_id       :integer
#
FactoryBot.define do
  factory :media do

    before(:create) do |media|
      item = FactoryBot.create(:item_object)
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
  end
end
