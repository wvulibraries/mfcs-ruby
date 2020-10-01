require 'rails_helper'

RSpec.describe Validator::DefinedValidations, type: :model do
  let(:form) { FactoryBot.create(:form) }
  let(:field_hash) do 
    field_hash = [{"max"=>"", "min"=>"", "name"=>"title", "step"=>"", "type"=>"text", "label"=>"AcquisitionTitle", "value"=>"", "css_id"=>"title", "format"=>"characters", "hidden"=>"", "disabled"=>"false", "field_id"=>"0", "help_url"=>"", "readonly"=>"false", "required"=>"true", "sortable"=>"", "css_class"=>"", "help_info"=>"", "help_type"=>"no_help", "searchable"=>"", "sort_order"=>"0", "validation"=>"", "placeholder"=>"", "local_styles"=>"width:90%;", "no_duplicates"=>"true", "public_release"=>"true", "display_in_list"=>"", "validation_regex"=>"", "disabled_on_insert"=>"false", "disabled_on_update"=>"false", "metadata_standards"=>[]}]
  end 

  # shared examples
  context 'base behaviors' do
    it_behaves_like 'a validator' 
  end

  context '.perform' do
    it 'returns blank because the type does not exist' do
      field_hash.first['validation'] = ''
      form.fields = field_hash
      form.save! 
      dv = Validator::DefinedValidations.new(form.id, 'title', 'input test')
      expect(dv.perform).to be true
    end
  end 

  context '.perform -> .regex' do
    it 'should return true for the matching expression' do
      field_hash.first['validation'] = 'regex'
      field_hash.first['validation_regex'] = '/\s/'
      form.fields = field_hash
      form.save! 
      str = 'something cool'
      dv = Validator::DefinedValidations.new(form.id, 'title', str)
      expect(dv.perform).to be true
    end 

    it 'should return false because it is no a string of whitespaces' do
      field_hash.first['validation'] = 'regex'
      field_hash.first['validation_regex'] = '/^\S*$/'
      form.fields = field_hash
      form.save! 
      str = 'something cool'
      dv = Validator::DefinedValidations.new(form.id, 'title', str)
      expect(dv.perform).to be false
    end 
  end
  

  context '.perform -> .phone_number' do
    valid_numbers = [
      '(333)111-2385',
      '333-111-2385',
      '333.111.2385',
      '333 111 2385',
      '(333) 111-2385',
      '(333).111.2385',
      '(333) 111 2385',
      '(333)111.2385',
      '1-230-234-2356'
    ]

    valid_numbers.each do |n|
      it "valid phone number -- #{n}" do
        field_hash.first['validation'] = 'phone_number'
        form.fields = field_hash
        form.save! 
        dv = Validator::DefinedValidations.new(form.id, 'title', n)
        expect(dv.perform).to be true
      end
    end

    invalid_numbers = [
      '123.234.123',
      'joe',
      '123-234-1234x',
      '1-230-234-2356x'
    ]
    invalid_numbers.each do |n|
      it "invalid phone number -- #{n}" do
        field_hash.first['validation'] = 'phone_number'
        form.fields = field_hash
        form.save! 
        dv = Validator::DefinedValidations.new(form.id, 'title', n)
        expect(dv.perform).to be false
      end
    end
  end

  context '.perform -> .url' do
    valid_options = [ 
      Faker::Internet.url, 
      'ftp://ftpserver.com/path/to/image.png',
      'ssh://user@host.example.com',
      'ssh://user@host.example.com:2222',
      'telnet://something.com',
      'https://www.google.com/?q=test&p=something'
    ]

    valid_options.each do |input|
      it "valid url -- #{input}" do
        field_hash.first['validation'] = 'url'
        form.fields = field_hash
        form.save! 
        dv = Validator::DefinedValidations.new(form.id, 'title', input)
        expect(dv.perform).to be true
      end
    end

    invalid_options = [
      'www.foo.com', 
      'http:/www.google.com', 
      'test', 
      '', 
      nil
    ]

    invalid_options.each do |input|
      it "invalid url -- #{input}" do
        field_hash.first['validation'] = 'url'
        form.fields = field_hash
        form.save! 
        dv = Validator::DefinedValidations.new(form.id, 'title', input)
        expect(dv.perform).to be false
      end
    end
  end

  context '.perform -> .optional_url' do
    valid_options = [ 
      Faker::Internet.url, 
      'ftp://ftpserver.com/path/to/image.png',
      'ssh://user@host.example.com',
      'ssh://user@host.example.com:2222',
      'telnet://something.com',
      'https://www.google.com/?q=test&p=something', 
      '',
      nil
    ]

    valid_options.each do |input|
      it "valid url -- #{input}" do
        field_hash.first['validation'] = 'optional_url'
        form.fields = field_hash
        form.save! 
        dv = Validator::DefinedValidations.new(form.id, 'title', input)
        expect(dv.perform).to be true
      end
    end

    invalid_options = [
      'www.foo.com', 
      'http:/www.google.com', 
      'test'
    ]

    invalid_options.each do |input|
      it "invalid url -- #{input}" do
        field_hash.first['validation'] = 'optional_url'
        form.fields = field_hash
        form.save! 
        dv = Validator::DefinedValidations.new(form.id, 'title', input)
        expect(dv.perform).to be false
      end
    end
  end

  context '.perform -> .email' do
    it 'valid email - manual' do
      field_hash.first['validation'] = 'email'
      form.fields = field_hash
      form.save! 
      dv = Validator::DefinedValidations.new(form.id, 'title', 'test@test.com')
      expect(dv.perform).to be true
    end

    it 'valid email - faker data' do
      field_hash.first['validation'] = 'email'
      form.fields = field_hash
      form.save! 
      dv = Validator::DefinedValidations.new(form.id, 'title', Faker::Internet.free_email)
      expect(dv.perform).to be true
    end

    it 'non-valid email' do
      field_hash.first['validation'] = 'email'
      form.fields = field_hash
      form.save! 
      dv = Validator::DefinedValidations.new(form.id, 'title', 'f@il:com')
      expect(dv.perform).to be false
    end
  end

  context '.perform -> .email_internal' do
    it 'valid email, but not internal' do
      field_hash.first['validation'] = 'email_internal'
      form.fields = field_hash
      form.save! 
      dv = Validator::DefinedValidations.new(form.id, 'title', Faker::Internet.free_email)
      expect(dv.perform).to be false
    end

    it 'valid wvu email old' do
      field_hash.first['validation'] = 'email_internal'
      form.fields = field_hash
      form.save! 
      dv = Validator::DefinedValidations.new(form.id, 'title', 'jjjameson@wvu.edu')
      expect(dv.perform).to be true
    end

    it 'valid wvu email new' do
      field_hash.first['validation'] = 'email_internal'
      form.fields = field_hash
      form.save! 
      dv = Validator::DefinedValidations.new(form.id, 'title', 'jjjameson@mail.wvu.edu')
      expect(dv.perform).to be true
    end
  end

  context '.perform -> .ip' do
    valid_ip = [ 
      Faker::Internet.public_ip_v4_address, 
      Faker::Internet.private_ip_v4_address, 
      Faker::Internet.ip_v4_cidr, 
      Faker::Internet.ip_v6_address, 
      Faker::Internet.ip_v6_cidr
    ]

    valid_ip.each do |ip| 
      it "valid ips -- #{ip} using the ip method" do
        field_hash.first['validation'] = 'ip'
        form.fields = field_hash
        form.save! 
        dv = Validator::DefinedValidations.new(form.id, 'title', ip)
        expect(dv.perform).to be true
      end

      it "valid ips -- #{ip} using the ip_range alias" do
        field_hash.first['validation'] = 'ip_range'
        form.fields = field_hash
        form.save! 
        dv = Validator::DefinedValidations.new(form.id, 'title', ip)
        expect(dv.perform).to be true
      end

      it "valid ips -- #{ip} using the ip_addr alias" do
        field_hash.first['validation'] = 'ip_addr'
        form.fields = field_hash
        form.save! 
        dv = Validator::DefinedValidations.new(form.id, 'title', ip)
        expect(dv.perform).to be true
      end
    end 

    it 'expects failure on fake ip' do
      field_hash.first['validation'] = 'ip'
      form.fields = field_hash
      form.save! 
      dv = Validator::DefinedValidations.new(form.id, 'title', '999.999.999.999')
      expect(dv.perform).to be false
    end
  end
  
  context '.perform -> .integer' do
    ['3000000', 3000, 3.08425].each do |int| 
      it "valid ints -- #{int}" do
        field_hash.first['validation'] = 'integer'
        form.fields = field_hash
        form.save! 
        dv = Validator::DefinedValidations.new(form.id, 'title', int)
        expect(dv.perform).to be true
      end
    end 
      
    it 'invalid int because of spaces' do
      field_hash.first['validation'] = 'integer'
      form.fields = field_hash
      form.save! 
      dv = Validator::DefinedValidations.new(form.id, 'title', '300000 0000')
    end 

    it 'invalid int because of characters' do
      field_hash.first['validation'] = 'integer'
      form.fields = field_hash
      form.save! 
      dv = Validator::DefinedValidations.new(form.id, 'title', '300000asdfads0000')
    end 
  end

  context '.perform -> .integer_spaces' do

    ['3000000', 3000, 3.08425, '  3   3  390384 ', '3 3', '3 '].each do |int| 
      it "valid ints -- #{int}" do
        field_hash.first['validation'] = 'integer_spaces'
        form.fields = field_hash
        form.save! 
        dv = Validator::DefinedValidations.new(form.id, 'title', int)
        expect(dv.perform).to be true
      end
    end 
    
    it 'invalid int because of text' do
      field_hash.first['validation'] = 'integer_spaces'
      form.fields = field_hash
      form.save! 
      dv = Validator::DefinedValidations.new(form.id, 'title', 'abacs0')
      puts dv.perform
      expect(dv.perform).to be false
    end 

    it 'invalid int because of characters' do
      field_hash.first['validation'] = 'integer_spaces'
      form.fields = field_hash
      form.save! 
      dv = Validator::DefinedValidations.new(form.id, 'title', '300000asdfads0000')
      puts dv.perform
      expect(dv.perform).to be false
    end 
  end

  context '.perform -> .alpha_numeric' do

    before(:each) do
      field_hash.first['validation'] = 'alpha_numeric'
      form.fields = field_hash
      form.save! 
    end

    it 'does not like scripty shenanigans' do
      str = "Somealpha823stuff\n<script>alert('pwned')</script>"
      dv = Validator::DefinedValidations.new(form.id, 'title', str)
      expect(dv.perform).to be false
    end

    it 'does not like other characters' do
      str = 'Some!_.asdf;'
      dv = Validator::DefinedValidations.new(form.id, 'title', str)
      expect(dv.perform).to be false
    end 
    
    it 'likes alphabets with spaces' do
      str = 'AlphaNumerical0003754'
      dv = Validator::DefinedValidations.new(form.id, 'title', str)
      expect(dv.perform).to be true
    end

    it 'likes numerical' do
      str = '8234985'
      dv = Validator::DefinedValidations.new(form.id, 'title', str)
      expect(dv.perform).to be true
    end
  end

  context '.perform -> .alpha_numeric_spaces' do

    before(:each) do
      field_hash.first['validation'] = 'alpha_numeric_spaces'
      form.fields = field_hash
      form.save! 
    end

    it 'does not like scripty shenanigans' do
      str = "Some alpha 823 stuff\n<script>alert('pwned')</script>"
      dv = Validator::DefinedValidations.new(form.id, 'title', str)
      expect(dv.perform).to be false
    end

    it 'does not like other characters' do
      str = 'Some alpha numerical with punctuation.'
      dv = Validator::DefinedValidations.new(form.id, 'title', str)
      expect(dv.perform).to be false
    end

    it 'likes alphabets with spaces' do
      str = 'Alpha Numerical stuff'
      dv = Validator::DefinedValidations.new(form.id, 'title', str)
      expect(dv.perform).to be true
    end
    
    it 'likes alpha and numerical stuff' do
      str = 'Cat20485'
      dv = Validator::DefinedValidations.new(form.id, 'title', str)
      expect(dv.perform).to be true
    end 

    it 'likes alph numerical with spaces' do
      str = 'Cat Number 12945'
      dv = Validator::DefinedValidations.new(form.id, 'title', str)
      expect(dv.perform).to be true
    end

    it 'likes numerical' do
      str = '8234985'
      dv = Validator::DefinedValidations.new(form.id, 'title', str)
      expect(dv.perform).to be true
    end
  end

  context '.perform -> .alpha' do

    before(:each) do
      field_hash.first['validation'] = 'alpha'
      form.fields = field_hash
      form.save! 
    end

    it 'hates alpha with spaces' do
      str = 'something cool spaces'
      dv = Validator::DefinedValidations.new(form.id, 'title', str)
      expect(dv.perform).to be false
    end

    it 'likes all alpha with no spaces' do
      str = 'somethingCoolMan'
      dv = Validator::DefinedValidations.new(form.id, 'title', str)
      expect(dv.perform).to be true
    end

    it 'hates punctuation marks' do
      str = 'somethingcool.'
      dv = Validator::DefinedValidations.new(form.id, 'title', str)
      expect(dv.perform).to be false
    end

    it 'hates numbers' do
      str = 'idonotlikenumbers284'
      dv = Validator::DefinedValidations.new(form.id, 'title', str)
      expect(dv.perform).to be false
    end
  end

  context '.perform -> .alpha_spaces' do
    
    before(:each) do
      field_hash.first['validation'] = 'alpha_spaces'
      form.fields = field_hash
      form.save! 
    end

    it 'like all alpha with spaces' do
      str = 'something cool spaces' 
      dv = Validator::DefinedValidations.new(form.id, 'title', str)
      expect(dv.perform).to be true
    end

    it 'likes all alpha with no spaces' do
      str = 'somethingCoolMan'
      dv = Validator::DefinedValidations.new(form.id, 'title', str)
      expect(dv.perform).to be true
    end

    it 'hates punctuation marks' do
      str = 'somethingcool.'
      dv = Validator::DefinedValidations.new(form.id, 'title', str)
      expect(dv.perform).to be false
    end

    it 'hates numbers' do
      str = 'idonotlikenumbers284'
      dv = Validator::DefinedValidations.new(form.id, 'title', str)
      expect(dv.perform).to be false
    end
  end
  
  context '.perform -> .no_special_chars' do

    before(:each) do
      field_hash.first['validation'] = 'no_special_chars'
      form.fields = field_hash
      form.save! 
    end

    chars = '!@#$%^&*()_+{}|:">?<[]\\\';,.`~µñ©æáßðøäåé®þüúíóö'
    char_array = chars.split('')
    char_array.each do |char|
      it "does not like #{char} as a character" do
        str = "#{char}"
        dv = Validator::DefinedValidations.new(form.id, 'title', str)
        expect(dv.perform).to be false
      end
    end

    it 'likes this because no special characters' do
      str = "testing something"
      dv = Validator::DefinedValidations.new(form.id, 'title', str)
      expect(dv.perform).to be true
    end
  end

  context '.perform -> .date' do

    before(:each) do
      field_hash.first['validation'] = 'date'
      form.fields = field_hash
      form.save! 
    end

    valid_edtf = [ 
      '119x',
      '2001-02-03',
      '2008',
      '1964/2008',
      '2004-06/2006-08',
      '2004-02-01/2005-02-08',
      '2005/2006-02',
      '1984?',
      '2004-06?',
      '2004-06-11?',
      '1984~',
      '1984?~',
      '199u',
      '19uu',
      '1999-uu',
      '1999-01-uu',
      '1999-uu-uu',
      '2004-06-01/unknown',
      '2004-01-01/open',
      '1984~/2004-06',
      '1984/2004-06~',
      '1984?/2004?~',
      'y170000002',
      'y-170000002',
      '2001-21',
      '2011-(06-04)~',
      '2011-23~',
      '2004?-06-(11)~',
      '156u-12-25',
      '15uu-12-25',
      '[1667,1668,1670..1672]',
      '{1667,1668,1670..1672}',
      '{1960,1961-12}'
    ]

    valid_edtf.each do |e|
      it "validates edtf date - #{e}" do
        dv = Validator::DefinedValidations.new(form.id, 'title', e)
        expect(dv.perform).to be true
      end
    end

    invalid_edtf = [
      'joes',
      '1800jdks',
      '1991/32/32'
    ]
    invalid_edtf.each do |e|
      it "does not validate edtf - #{e}" do
        dv = Validator::DefinedValidations.new(form.id, 'title', e)
        expect(dv.perform).to be false
      end
    end
  end

  context '.perform -> .no_spaces' do

    before(:each) do
      field_hash.first['validation'] = 'no_spaces'
      form.fields = field_hash
      form.save! 
    end

    it 'should return false the string has spaces' do
      str = ' sme string with spaces '
      dv = Validator::DefinedValidations.new(form.id, 'title', str)
      expect(dv.perform).to be false
    end
    
    it 'should return true the string has no spaces' do
      str = 'as;dlfkjas;dflkjasd;lfkjasd;f'
      dv = Validator::DefinedValidations.new(form.id, 'title', str)
      expect(dv.perform).to be true
    end
  end
end 