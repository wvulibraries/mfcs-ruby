require 'rails_helper'

RSpec.describe TextField, type: :model do
  context 'validations' do
    # from parent class
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:type) }
    it { should validate_presence_of(:label) }
  end

  context 'enumerations' do
    it { should define_enum_for(:format) }
    it { should define_enum_for(:format).with_values('Characters' => 0, 'Words' => 1) }
  end
end
