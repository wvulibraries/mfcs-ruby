# sharable module
RSpec.shared_examples 'helpable' do
  context 'enumeration' do
    it { should define_enum_for(:help_type).with_values(no_help: 0, plain_text: 1, html_text: 2, web_url: 3) }
  end

  context 'common help field information' do
    it { should have_db_column(:help_type).of_type(:integer) }
    it { should have_db_column(:help_info).of_type(:string) }
  end
end
