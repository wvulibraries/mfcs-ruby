require 'rails_helper'

RSpec.describe Validator::TextLength, type: :model do
  let(:form) { FactoryBot.create(:form) }
  let(:field_hash) do 
    field_hash = [{"max"=>"", "min"=>"", "name"=>"title", "step"=>"", "type"=>"text", "label"=>"AcquisitionTitle", "value"=>"", "css_id"=>"title", "format"=>"characters", "hidden"=>"", "disabled"=>"false", "field_id"=>"0", "help_url"=>"", "readonly"=>"false", "required"=>"true", "sortable"=>"", "css_class"=>"", "help_info"=>"", "help_type"=>"no_help", "searchable"=>"", "sort_order"=>"0", "validation"=>"", "placeholder"=>"", "local_styles"=>"width:90%;", "no_duplicates"=>"true", "public_release"=>"true", "display_in_list"=>"", "validation_regex"=>"", "disabled_on_insert"=>"false", "disabled_on_update"=>"false", "metadata_standards"=>[]}]
  end 

  # shared examples
  # context 'inherits from Validator::Base using shared examples' do
  #   it_behaves_like 'a validator' 
  # end

  context 'After Init' do

    context 'instance variables that should be set' do 
      before(:each) do
        form.fields = field_hash 
        form.save!
      end
      
      it '@form' do
        text_length = Validator::TextLength.new(form.id, 'title', 'something')
        expect(text_length.instance_variable_defined?(:@form)).to be true
      end 

      it '@form_field' do
        text_length = Validator::TextLength.new(form.id, 'title', 'something')
        expect(text_length.instance_variable_defined?(:@form_field)).to be true
      end 

      it '@min' do
        text_length = Validator::TextLength.new(form.id, 'title', 'something')
        expect(text_length.instance_variable_defined?(:@min)).to be true
      end 

      it '@max' do
        text_length = Validator::TextLength.new(form.id, 'title', 'something')
        expect(text_length.instance_variable_defined?(:@max)).to be true
      end 

      it '@format' do
        text_length = Validator::TextLength.new(form.id, 'title', 'something')
        expect(text_length.instance_variable_defined?(:@min)).to be true
      end 
    end 

    context '.default_min' do  
      it 'set default min with a numerical string' do 
        field_hash.first['min'] = '1'
        form.fields = field_hash 
        form.save!
        text_length = Validator::TextLength.new(form.id, 'title', 'something')
        expect(text_length.default_min).to eq '1'
      end 

      it 'sets default min to 0 if nil' do 
        field_hash.first['min'] = nil
        form.fields = field_hash 
        form.save!
        text_length = Validator::TextLength.new(form.id, 'title', 'something')
        expect(text_length.default_min).to eq 0
      end 

      it 'sets default min to 0 if empty' do 
        field_hash.first['min'] = ''
        form.fields = field_hash 
        form.save!
        text_length = Validator::TextLength.new(form.id, 'title', 'something')
        expect(text_length.default_min).to eq 0
      end 
    end

    context '.default_max' do  
      it 'set default max with a numerical string' do 
        field_hash.first['max'] = '500'
        form.fields = field_hash 
        form.save!
        text_length = Validator::TextLength.new(form.id, 'title', 'something')
        expect(text_length.default_max).to eq '500'
      end 

      it 'sets default max to 0 if nil' do 
        field_hash.first['max'] = nil
        form.fields = field_hash 
        form.save!
        text_length = Validator::TextLength.new(form.id, 'title', 'something')
        expect(text_length.default_max).to eq 30_000
      end 

      it 'sets default max to 0 if empty' do 
        field_hash.first['max'] = ''
        form.fields = field_hash 
        form.save!
        text_length = Validator::TextLength.new(form.id, 'title', 'something')
        expect(text_length.default_max).to eq 30_000
      end 
    end

    context '.default_format' do  
      it 'set default format with a numerical string' do 
        field_hash.first['format'] = 'word'
        form.fields = field_hash 
        form.save!
        text_length = Validator::TextLength.new(form.id, 'title', 'something')
        expect(text_length.default_format).to eq 'word'
      end 

      it 'sets default format to 0 if nil' do 
        field_hash.first['format'] = nil
        form.fields = field_hash 
        form.save!
        text_length = Validator::TextLength.new(form.id, 'title', 'something')
        expect(text_length.default_format).to eq 'characters'
      end 

      it 'sets default format to 0 if empty' do 
        field_hash.first['format'] = ''
        form.fields = field_hash 
        form.save!
        text_length = Validator::TextLength.new(form.id, 'title', 'something')
        expect(text_length.default_format).to eq 'characters'
      end 
    end
  end
  
  context '.character_limits' do
    before(:each) do
      form.fields = field_hash 
      form.save!
    end

    it 'between character limits' do
      txt_str = "testing"
      text_length = Validator::TextLength.new(form.id, 'title', txt_str)
      expect(text_length.character_limits(txt_str, 2, 7)).to be true
    end

    it 'under minimum limits' do
      txt_str = "te"
      text_length = Validator::TextLength.new(form.id, 'title', txt_str)
      expect(text_length.character_limits(txt_str, 5, 7)).to be false
    end

    it 'above character limits' do
      txt_str = "testing something really cool"
      text_length = Validator::TextLength.new(form.id, 'title', txt_str)
      expect(text_length.character_limits(txt_str, 2, 7)).to be false
    end
  end

  context '.word_limits' do
    before(:each) do
      form.fields = field_hash 
      form.save!
    end
    
    it 'between character limits' do
      txt_str = "testing some string"
      text_length = Validator::TextLength.new(form.id, 'title', txt_str)
      expect(text_length.word_limits(txt_str, 2, 4)).to be true
    end

    it 'under minimum limits' do
      txt_str = "testing some string"
      text_length = Validator::TextLength.new(form.id, 'title', txt_str)
      expect(text_length.word_limits(txt_str, 5, 7)).to be false
    end

    it 'above max limits' do
      txt_str = "testing something really cool which is a bad thing"
      text_length = Validator::TextLength.new(form.id, 'title', txt_str)
      expect(text_length.word_limits(txt_str, 2, 7)).to be false
    end
  end
  
end 