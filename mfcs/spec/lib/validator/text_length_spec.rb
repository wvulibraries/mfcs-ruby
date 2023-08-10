require 'rails_helper'

RSpec.describe Validator::TextLength, type: :model do
  # shared examples
  context 'base behaviors' do
    it_behaves_like 'a validator object' 
  end

  let(:field_hash) do 
    {"max"=>"", "min"=>"", "name"=>"title", "type"=>"text", "label"=>"Title", "value"=>"", "css_id"=>"", "format"=>"characters", "hidden"=>false, "disabled"=>false, "field_id"=>"9439454999752343", "help_url"=>"", "required"=>true, "sortable"=>true, "css_class"=>"", "help_info"=>"", "help_type"=>"", "read_only"=>false, "searchable"=>true, "sort_order"=>"2", "validation"=>"", "oai_release"=>false, "placeholder"=>"", "local_styles"=>"", "no_duplicates"=>false, "public_release"=>true, "display_in_list"=>false, "validation_regex"=>"", "disabled_on_insert"=>false, "disabled_on_update"=>false, "metadata_standards"=>""}
  end 

  context 'methods' do
    before(:each) do
      @base =  described_class.new('test_input', {'testing': 'soemthing here'}, 1)
    end

    it '.character_limits' do
      expect(@base).respond_to? :character_limits
    end

    it '.word_limits' do
      expect(@base).respond_to? :word_limits
    end   
    
    it '.default_min' do
      expect(@base).respond_to? :default_min
    end   
    
    it '.default_max' do
      expect(@base).respond_to? :default_max
    end   
    
    it '.format' do
      expect(@base).respond_to? :format
    end   
  end

  context 'after_initialize' do
    before(:each) do
      @base = described_class.new({'testing': 'soemthing here'}, 'test_input', 1)
    end

    it '@min' do
      expect(@base.instance_variable_defined?(:@min)).to be true
    end 

    it '@max' do
      expect(@base.instance_variable_defined?(:@max)).to be true
    end 

    it '@format' do
      expect(@base.instance_variable_defined?(:@format)).to be true
    end 
  end

  context '.default_min' do  
    it 'set default min with a numerical string' do 
      field_hash['min'] = '1'
      input = 'test string'
      base = described_class.new(input, field_hash, 1)
      expect(base.default_min).to eq 1
    end 

    it 'sets default min to 0 if nil' do 
      field_hash['min'] = nil
      input = 'test string'
      base = described_class.new(input, field_hash, 1)
      expect(base.default_min).to eq 0
    end 

    it 'sets default min to 0 if empty' do 
      field_hash['min'] = ''
      input = 'test string'
      base = described_class.new(input, field_hash, 1)
      expect(base.default_min).to eq 0
    end 
  end

  context '.default_max' do  
    it 'set default min with a numerical string' do 
      field_hash['max'] = '1'
      input = 'test string'
      base = described_class.new(input, field_hash, 1)
      expect(base.default_max).to eq 1
    end 

    it 'sets default min to 0 if nil' do 
      field_hash['max'] = nil
      input = 'test string'
      base = described_class.new(input, field_hash, 1)
      expect(base.default_max).to eq 30000
    end 

    it 'sets default min to 0 if empty' do 
      field_hash['max'] = ''
      input = 'test string'
      base = described_class.new(input, field_hash, 1)
      expect(base.default_max).to eq 30000
    end 
  end

  context '.format' do
    it 'set default format with a numerical string' do 
      field_hash['format'] = 'word'
      input = 'test string'
      base = described_class.new(input, field_hash, 1)
      expect(base.format).to eq 'word'
    end 

    it 'sets default format to 0 if nil' do 
      field_hash['format'] = nil
      input = 'test string'
      base = described_class.new(input, field_hash, 1)
      expect(base.format).to eq 'characters'
    end 

    it 'sets default format to 0 if empty' do 
      field_hash['format'] = ''
      input = 'test string'
      base = described_class.new(input, field_hash, 1)
      expect(base.format).to eq 'characters'
    end 
  end

  context '.perform' do
    context '.word_limits' do
      it 'between word limits' do
        field_hash['format'] = 'word'
        field_hash['min'] = 1
        field_hash['max'] = 5
        input = 'testing class thing'
        base = described_class.new(input, field_hash, 1)
        expect(base.perform).to be true
      end
  
      it 'under minimum limits' do
        field_hash['format'] = 'word'
        field_hash['min'] = 2
        field_hash['max'] = 5
        input = 'testing'
        base = described_class.new(input, field_hash, 1)
        expect(base.perform).to be false
      end
  
      it 'above word limits' do
        field_hash['format'] = 'word'
        field_hash['min'] = 1
        field_hash['max'] = 5
        input = 'testing the max amount in this string'
        base = described_class.new(input, field_hash, 1)
        expect(base.perform).to be false
      end

      it 'max and min equal so there is nothing to test' do
        field_hash['format'] = 'word'
        field_hash['min'] = 100
        field_hash['max'] = 100
        input = 'testing'
        base = described_class.new(input, field_hash, 1)
        expect(base.perform).to be true
      end
    end
    
    context '.character_limits' do
      it 'between character limits' do
        field_hash['format'] = 'characters'
        field_hash['min'] = 1
        field_hash['max'] = 20
        input = 'testing'
        base = described_class.new(input, field_hash, 1)
        expect(base.perform).to be true
      end
  
      it 'under minimum limits' do
        field_hash['format'] = 'characters'
        field_hash['min'] = 10
        field_hash['max'] = 20
        input = 'testing'
        base = described_class.new(input, field_hash, 1)
        expect(base.perform).to be false
      end
  
      it 'above character limits' do
        field_hash['format'] = 'characters'
        field_hash['min'] = 1
        field_hash['max'] = 5
        input = 'testing'
        base = described_class.new(input, field_hash, 1)
        expect(base.perform).to be false
      end

      it 'max and min equal so there is nothing to test' do
        field_hash['format'] = 'characters'
        field_hash['min'] = 100
        field_hash['max'] = 100
        input = 'testing'
        base = described_class.new(input, field_hash, 1)
        expect(base.perform).to be true
      end
    end 
  end 
end 