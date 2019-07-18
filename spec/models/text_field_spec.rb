require 'rails_helper'

RSpec.describe TextField, type: :model do
  context 'database columns' do
    context 'strings' do
      it { should have_db_column(:name).of_type(:string) }
      it { should have_db_column(:label).of_type(:string) }
      it { should have_db_column(:type).of_type(:string) }
      it { should have_db_column(:value).of_type(:string) }
      it { should have_db_column(:placeholder).of_type(:string) }
      it { should have_db_column(:css_id).of_type(:string) }
      it { should have_db_column(:css_class).of_type(:string) }
      it { should have_db_column(:local_styles).of_type(:string) }
      it { should have_db_column(:help_type).of_type(:string) }
      it { should have_db_column(:help_info).of_type(:string) }
      it { should have_db_column(:validation).of_type(:string) }
    end

    context 'booleans' do
      it { should have_db_column(:required).of_type(:boolean) }
      it { should have_db_column(:no_duplicates).of_type(:boolean) }
      it { should have_db_column(:read_only).of_type(:boolean) }
      it { should have_db_column(:disabled).of_type(:boolean) }
      it { should have_db_column(:disabled_on_insert).of_type(:boolean) }
      it { should have_db_column(:public_release).of_type(:boolean) }
      it { should have_db_column(:oai_release).of_type(:boolean) }
      it { should have_db_column(:sortable).of_type(:boolean) }
      it { should have_db_column(:searchable).of_type(:boolean) }
      it { should have_db_column(:display_in_list).of_type(:boolean) }
      it { should have_db_column(:hidden).of_type(:boolean) }
    end

    context 'integers' do
      it { should have_db_column(:position).of_type(:integer) }
      it { should have_db_column(:min).of_type(:integer) }
      it { should have_db_column(:max).of_type(:integer) }
    end
  end

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
