# Fieldable shared example.
RSpec.shared_examples 'fieldable' do
  context 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:type) }
    it { should validate_presence_of(:label) }
  end

  context 'associations' do
    it { should have_one(:field) }
    it { should have_one(:form).through(:field) }
  end
end
