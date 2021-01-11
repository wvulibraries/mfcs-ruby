require 'rails_helper'

RSpec.describe Idno::SystemIdno, type: :model do
  let(:field_info) do 
    field_info = {"name"=>"idno", "type"=>"idno", "label"=>"Identifier", "value"=>"", "css_id"=>"", "hidden"=>false, "disabled"=>false, "field_id"=>"9429974999744445", "help_url"=>"", "required"=>true, "sortable"=>true, "css_class"=>"", "help_info"=>"", "help_type"=>"", "read_only"=>false, "managed_by"=>"System", "searchable"=>true, "sort_order"=>"1", "validation"=>"", "idno_format"=>"testing_#####_idno", "oai_release"=>true, "placeholder"=>"", "local_styles"=>"", "no_duplicates"=>true, "public_release"=>true, "display_in_list"=>true, "start_increment"=>"", "validation_regex"=>"", "disabled_on_insert"=>false, "disabled_on_update"=>false, "metadata_standards"=>[]}
  end 

  context '.init' do
    it 'initalizes' do
      idno = described_class.new(1, field_info)
      expect(idno).to be_a described_class
    end

    it "assigned @form_id" do
      idno = described_class.new(1, field_info)
      expect(idno.instance_variable_defined?(:@form_id)).to be true
    end

    it "assigned @pattern" do
      idno = described_class.new(1, field_info)
      expect(idno.instance_variable_defined?(:@pattern)).to be true
    end

    it "assigned @start_count" do
      idno = described_class.new(1, field_info)
      expect(idno.instance_variable_defined?(:@pattern)).to be true
    end
  end

  context '.formatted_idno' do
    before(:each) do
      @form = FactoryBot.create(:object_form)
      5.times do
        item = FactoryBot.build(:metadata)
        item.data = {"title" => "#{Faker::Movies::LordOfTheRings.character}"}
        item.form_id = @form.id
        item.save(validate: false)
      end 
    end
    
    it 'formats the idno using the item count and the pattern' do
      field_info['idno_format'] = 'testing_#####' 
      field_info['start_increment'] = ''
      idno = described_class.new(@form.id, field_info)
      expect(idno.formatted_idno).to eq 'testing_00005'
    end 

    it 'empty record formatting' do
      form = FactoryBot.create(:object_form)
      form.save
      field_info['idno_format'] = 'testing_#####' 
      field_info['start_increment'] = ''
      idno = described_class.new(form.id, field_info)
      expect(idno.formatted_idno).to eq 'testing_00001'
    end 

    it 'empty record formatting with starting' do
      form = FactoryBot.create(:object_form)
      form.save
      field_info['idno_format'] = 'testing_#####' 
      field_info['start_increment'] = '77'
      idno = described_class.new(form.id, field_info)
      expect(idno.formatted_idno).to eq 'testing_00077'
    end 
  end 

  context '.item_count' do
    before(:each) do
      @form = FactoryBot.create(:object_form)
    end

    it 'returns a count of items in the database' do
      5.times do
        item = FactoryBot.build(:metadata)
        item.data = {"title" => "#{Faker::Movies::LordOfTheRings.character}"}
        item.form_id = @form.id
        item.save(validate: false)
      end 
      idno = described_class.new(@form.id, field_info)
      expect(idno.item_count).to eq 5
    end 

    it 'returns 1 if the count is 0' do
      idno = described_class.new(@form.id, field_info)
      expect(idno.item_count).to eq 1
    end 

    it 'returns a higher number if the count is 0  and the start is set' do
      field_info['start_increment'] = 10
      idno = described_class.new(@form.id, field_info)
      expect(idno.item_count).to eq 10
    end 

    it 'starts at the current number, then adds the count to that' do
      5.times do
        item = FactoryBot.build(:metadata)
        item.data = {"title" => "#{Faker::Movies::LordOfTheRings.character}"}
        item.form_id = @form.id
        item.save(validate: false)
      end 
      field_info['start_increment'] = 10
      idno = described_class.new(@form.id, field_info)
      expect(idno.item_count).to eq 15
    end 
  end 

  context '.create_idno' do 
    it 'results in a padding string out of the count and padding' do
      idno = described_class.new(1, field_info)
      expect(idno.create_idno(14, 99)).to be_a String
    end 

    it 'should equal 000000014' do
      idno = described_class.new(1, field_info)
      expect(idno.create_idno(14, 9)).to eq '000000014'
    end
    
    it 'should equal 01' do
      idno = described_class.new(1, field_info)
      expect(idno.create_idno(1, 2)).to eq '01'
    end 

    it 'should equal 100' do
      idno = described_class.new(1, field_info)
      expect(idno.create_idno(100, 2)).to eq '100'
    end 
  end 

  context '.padding_size' do
    it 'returns an integer' do
      field_info['idno_format'] = 'testing_#####' 
      idno = described_class.new(1, field_info)
      size = idno.padding_size
      expect(size).to be_a Integer
    end 

    it 'expects the returned integer to be 5' do
      field_info['idno_format'] = 'testing_#####' 
      idno = described_class.new(1, field_info)
      size = idno.padding_size
      expect(size).to eq 5
    end

    it 'expects the returned integer to be 1' do
      field_info['idno_format'] = 'testing_#' 
      idno = described_class.new(1, field_info)
      size = idno.padding_size
      expect(size).to eq 1
    end 
  end 
end 