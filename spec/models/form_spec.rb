require 'rails_helper'

RSpec.describe Form, type: :model do
  # validations
  context 'validations' do
    context 'Form.title' do
      it { should validate_presence_of(:title) }
      it { should validate_length_of(:title).is_at_least(1) }
      it { should validate_length_of(:title).is_at_most(250) }
      it { should validate_uniqueness_of(:title) }
    end

    context 'Form.display_title' do
      it { should validate_presence_of(:display_title) }
      it { should validate_length_of(:display_title).is_at_least(1) }
      it { should validate_length_of(:display_title).is_at_most(250) }
      it { should validate_uniqueness_of(:display_title) }
    end

    context 'Form.idno' do
      it { should validate_presence_of(:idno) }
      it { should validate_length_of(:idno).is_at_least(1) }
      it { should validate_length_of(:idno).is_at_most(250) }
      it { should validate_uniqueness_of(:idno) }
    end
  end
end
