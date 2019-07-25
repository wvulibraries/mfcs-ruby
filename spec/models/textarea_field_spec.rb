require 'rails_helper'
require './spec/shared/a_field'

RSpec.describe TextareaField, type: :model do
  context 'database columns' do
    # covers all default field items
    it_behaves_like 'a field'

    context 'text field specific' do
      context 'strings' do
        it { should have_db_column(:validation).of_type(:string) }
        it { should have_db_column(:validation_regex).of_type(:string) }
        it { should have_db_column(:placeholder).of_type(:string) }
      end

      context 'integers' do
        it { should have_db_column(:min).of_type(:integer) }
        it { should have_db_column(:max).of_type(:integer) }
        it { should have_db_column(:format).of_type(:integer) }
      end
    end
  end

  context 'enumerations' do
    it { should define_enum_for(:format) }
    it { should define_enum_for(:format).with_values('Characters' => 0, 'Words' => 1) }
  end
end
