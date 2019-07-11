require 'rails_helper'

RSpec.describe Field, type: :model do
  context 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:type) }
    it { should validate_presence_of(:label) }
  end
end
