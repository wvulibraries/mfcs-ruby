RSpec.shared_examples "a field" do
  context 'should have common database fields' do
    context 'strings' do
      it { should have_db_column(:name).of_type(:string) }
      it { should have_db_column(:label).of_type(:string) }
      it { should have_db_column(:type).of_type(:string) }
      it { should have_db_column(:value).of_type(:string) }
      it { should have_db_column(:css_id).of_type(:string) }
      it { should have_db_column(:css_class).of_type(:string) }
      it { should have_db_column(:local_styles).of_type(:string) }
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
    end
  end
end