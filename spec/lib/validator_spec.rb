require 'rails_helper'

RSpec.describe Validator, type: :model do

  context '.regex' do
    it 'should return true for the matching expression' do
      regex = '/\s/'
      str = 'something cool'
      expect(Validator.regex(str, regex)).to be true
    end 

    it 'should return true for the matching expression' do
      regex = '/\s/'
      str = 'somethingcool'
      expect(Validator.regex(str, regex)).to be true
    end 
  end 

  context '.handle_type_validation' do
    context 'valid examples' do
      valid_examples = [
        { type: 'phone_number', input: '304.234.2324' }, 
        { type: 'ip_addr', input: '127.0.0.1' }, 
        { type: 'ip_range', input: '127.0.0.1/8' }, 
        { type: 'url', input: Faker::Internet.url }, 
        { type: 'optional_url', input: '' }, 
        { type: 'email_addr', input: Faker::Internet.free_email }, 
        { type: 'internal_email_addr', input: 'jjjameson@wvu.edu' }, 
        { type: 'integer', input: '1' }, 
        { type: 'integer_spaces', input: '1  2   3' }, 
        { type: 'alpha', input: 'asdfa sdf sadfasd' },
        { type: 'alpha_no_spaces', input: 'asdfasdsadfasd' },
        { type: 'alpha_numeric', input: 'asdfasdfs adfasd 12344' },
        { type: 'alpha_numeric_no_space', input: 'asdfas234fsadfasd' },
        { type: 'no_spaces', input: 'asdfasdfsadfasd' },
        { type: 'no_special_chars', input: 'asdfasdfsadfasd' }
      ]

      valid_examples.each do |n|
        it "valid test for #{n[:type]} using #{n[:input]}" do
          expect(Validator.handle_type_validation(n[:input], n[:type])).to be true
        end
      end
    end 

    context 'not_valid examples' do
      not_valid_examples = [
        { type: 'phone_number', input: '3adsfasfd04.234.2324' }, 
        { type: 'ip_addr', input: '127.0.0.asdf1' }, 
        { type: 'ip_range', input: '127.0.0.1/8asdf' }, 
        { type: 'url', input: 'Franks Hideaway' }, 
        { type: 'optional_url', input: '13' }, 
        { type: 'email_addr', input:  'Failbot@internts.asd;flkjasdflaksdjf;asdlkfja'}, 
        { type: 'internal_email_addr', input: Faker::Internet.free_email }, 
        { type: 'integer', input: '1a' }, 
        { type: 'integer_spaces', input: '1a  --' }, 
        { type: 'alpha', input: 'asdfa12$' },
        { type: 'alpha_no_spaces', input: 'asdfasdsd fasd' },
        { type: 'alpha_numeric', input: 'asdfasdfs adfasd 12344$%' },
        { type: 'alpha_numeric_no_space', input: 'asdf as 234' },
        { type: 'no_spaces', input: ' asdfasdfsadfasd ' },
        { type: 'no_special_chars', input: '"somethingCool!@#$%*()"' }
      ]

      not_valid_examples.each do |n|
        it "valid test for #{n[:type]} using #{n[:input]}" do
          expect(Validator.handle_type_validation(n[:input], n[:type])).to be false
        end
      end
    end 

  end
  
  context '.phone_number' do
    it 'valid phone numbers return true' do
      valid_phone = '304.283.1845'
      valid = Validator.phone_number(valid_phone)
      expect(valid).to be true
    end

    it 'invalid phone numbers return false' do
      invalid_phone = 'Not a Phone'
      valid = Validator.phone_number invalid_phone
      expect(valid).to be false
    end

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
      it "valid #{n}" do
        expect(Validator.phone_number(n)).to be true
      end
    end

    invalid_numbers = [
      '123.234.123',
      'joe',
      '123-234-1234x',
      '1-230-234-2356x'
    ]
    invalid_numbers.each do |n|
      it "invalid #{n}" do
        expect(Validator.phone_number(n)).to be false
      end
    end
  end

  context '.limit_words' do
    it 'less than limit - manual string' do
      test_string = 'Some words that have one-way hyphens and stuff.'
      expect(Validator.limit_words(test_string, 10)).to be true
    end

    it 'less than limit - automated string' do
      expect(Validator.limit_words(Faker::Lorem.sentence(word_count: 8), 10)).to be true
    end

    it 'string has equal words than the limit' do
      test_string = 'Some words that have one-way hyphens and stuff.'
      expect(Validator.limit_words(test_string, 8)).to be true
    end

    it 'equal to limit - automated string' do
      expect(Validator.limit_words(Faker::Lorem.sentence(word_count: 10), 10)).to be true
    end

    it 'more than limit - manual string' do
      test_string = 'Some words that have one-way hyphens and stuff.'
      expect(Validator.limit_words(test_string, 3)).to be false
    end

    it 'more than limit - automated string' do
      expect(Validator.limit_words(Faker::Lorem.sentence(word_count: 12), 3)).to be false
    end
  end

  context '.limit_chars' do
    it 'less than limit' do
      expect(Validator.limit_chars(Faker::Lorem.characters(number: 4), 10)).to be true
    end

    it 'equal to limit' do
      expect(Validator.limit_chars(Faker::Lorem.characters(number: 8), 8)).to be true
    end

    it 'more than limit' do
      expect(Validator.limit_chars(Faker::Lorem.characters(number: 12), 7)).to be false
    end
  end

  context '.text_length' do

    context 'words' do
      it 'returns true min and max and not added and the number of words is between 0 and 30000' do
        txt_str = Faker::Lorem.sentence(word_count: 5)
        expect(Validator.text_length(txt_str, type: 'word')).to be true
      end 

      it 'returns true, because text string is empty there is no min' do
        txt_str = ''
        expect(Validator.text_length(txt_str, type: 'word')).to be true
      end 

      it 'returns false, string is larger than max words' do
        txt_str = Faker::Lorem.sentence(word_count: 15)
        expect(Validator.text_length(txt_str, max: 10, type: 'word')).to be false
      end 

      it 'returns false, string does not meet min requirements' do
        txt_str = Faker::Lorem.sentence(word_count: 5)
        expect(Validator.text_length(txt_str, min: 10, type: 'word')).to be false
      end 
    end
    
    context 'characters' do
      it 'defaults to characters' do
        txt_str = Faker::Lorem.characters(number: 5)
        expect(Validator.text_length(txt_str, min: 1, max:10)).to be true

        txt_str = Faker::Lorem.characters(number: 12)
        expect(Validator.text_length(txt_str, min: 1, max:10)).to be false
      end 

      it 'returns true min and max and not added and the number of words is between 0 and 30000' do
        txt_str = Faker::Lorem.characters(number: 5)
        expect(Validator.text_length(txt_str, type: 'characters')).to be true
      end 

      it 'returns true, because text string is empty there is no min' do
        txt_str = ''
        expect(Validator.text_length(txt_str, type: 'characters')).to be true
      end 

      it 'returns false, string is larger than max words' do
        txt_str = Faker::Lorem.characters(number: 15)
        expect(Validator.text_length(txt_str, max: 10, type: 'characters')).to be false
      end 

      it 'returns false, string does not meet min requirements' do
        txt_str = Faker::Lorem.characters(number: 5)
        expect(Validator.text_length(txt_str, min: 10, type: 'characters')).to be false
      end 
    end 
  end 

  context '.text_character_limits' do
    it 'between character limits' do
      txt_str = "testing"
      expect(Validator.text_character_limits(txt_str, 2, 7)).to be true
    end

    it 'under minimum limits' do
      txt_str = "te"
      expect(Validator.text_character_limits(txt_str, 5, 7)).to be false
    end

    it 'above character limits' do
      txt_str = "testing something really cool"
      expect(Validator.text_character_limits(txt_str, 2, 7)).to be false
    end
  end

  context '.text_word_limits' do
    it 'between character limits' do
      txt_str = "testing some string"
      expect(Validator.text_word_limits(txt_str, 2, 4)).to be true
    end

    it 'under minimum limits' do
      txt_str = "testing some string"
      expect(Validator.text_word_limits(txt_str, 5, 7)).to be false
    end

    it 'above max limits' do
      txt_str = "testing something really cool which is a bad thing"
      expect(Validator.text_word_limits(txt_str, 2, 7)).to be false
    end
  end
  

  context '.ip' do
    it 'public ipv4 address' do
      expect(Validator.ip(Faker::Internet.public_ip_v4_address)).to be true
    end
    it 'private ipv4 address' do
      expect(Validator.ip(Faker::Internet.private_ip_v4_address)).to be true
    end
    it 'ipv4 cidr' do
      expect(Validator.ip(Faker::Internet.ip_v4_cidr)).to be true
    end
    it 'ipv6' do
      expect(Validator.ip(Faker::Internet.ip_v6_address)).to be true
    end 
    it 'ipv6 cidr' do
      expect(Validator.ip(Faker::Internet.ip_v6_cidr)).to be true
    end 
    it 'expects failure on fake ip' do
      expect(Validator.ip('999.999.999.999')).to be false
    end
  end

  context '.url' do
    it 'flexible validation of a url, should validate any valid url' do
      expect(Validator.url(Faker::Internet.url)).to be true
    end
    it 'ftp works' do
      expect(Validator.url('ftp://ftpserver.com/path/to/image.png')).to be true
    end 
    it 'ssh works' do
      expect(Validator.url('ssh://user@host.example.com')).to be true 
    end
    it 'ssh with port works' do
      expect(Validator.url('ssh://user@host.example.com:2222')).to be true 
    end
    it 'telnet works' do
      expect(Validator.url('telnet://something.com')).to be true
    end
    it 'query strings work' do
      expect(Validator.url('https://www.google.com/?q=test&p=something'))
    end
    it 'invalid url without protocol' do
      expect(Validator.url('www.foo.com')).to be false
    end
    it 'invalid url malformed protocol' do
      expect(Validator.url('http:/www.google.com')).to be false
    end
    it 'fails on non-url' do
      expect(Validator.url('test')).to be false
    end
  end

  context '.optional_url' do
    it 'expects blank to be true' do
      expect(Validator.optional_url('')).to be true
    end
    it 'expects nil to be true' do
      expect(Validator.optional_url(nil)).to be true
    end 
    it 'ftp works' do
      expect(Validator.url('ftp://ftpserver.com/path/to/image.png')).to be true
    end 
    it 'ssh works' do
      expect(Validator.url('ssh://user@host.example.com')).to be true 
    end
    it 'ssh with port works' do
      expect(Validator.url('ssh://user@host.example.com:2222')).to be true 
    end
    it 'telnet works' do
      expect(Validator.url('telnet://something.com')).to be true
    end
    it 'query strings work' do
      expect(Validator.url('https://www.google.com/?q=test&p=something'))
    end
    it 'invalid url without protocol' do
      expect(Validator.url('www.foo.com')).to be false
    end
  end

  context '.email' do
    it 'valid email - manual' do
      expect(Validator.email('test@test.com')).to be true
    end
    it 'valid email - faker data' do
      expect(Validator.email(Faker::Internet.free_email)).to be true
    end
    it 'non-valid email' do
      expect(Validator.email('f@il:com')).to be false
    end
  end

  context '.email_internal' do
    it 'valid email, but not internal' do
      expect(Validator.email_internal(Faker::Internet.free_email)).to be false
    end

    it 'valid wvu email old' do
      expect(Validator.email_internal('jjjameson@wvu.edu')).to be true
    end

    it 'valid wvu email new' do
      expect(Validator.email_internal('jjjameson@mail.wvu.edu')).to be true
    end
  end

  context '.integer' do
    it 'valid string' do
      expect(Validator.integer('300000')).to be true
    end
    it 'valid int' do
      expect(Validator.integer(3000)).to be true
    end
    it 'valid float' do
      expect(Validator.integer(3.08345)).to be true
    end
    it 'not valid string - space' do
      expect(Validator.integer('30000 000')).to be false
    end
    it 'not valid number - letter' do
      expect(Validator.integer('3000a')).to be false
    end
  end

  context '.divisible_by_step?' do 
    it 'returns valid or true because the step is 0' do
      expect(Validator.divisible_by_step?(15,0)).to be true
    end 
    
    it 'step is a multiple of the number' do
      expect(Validator.divisible_by_step?(9,3)).to be true
    end

    it 'step is not a multiple of the number' do
      expect(Validator.divisible_by_step?(9,5)).to be false
    end
  end 

  context '.between_min_max?' do
    it 'validates because no max number or max number not positive' do
      max = [nil, 0]
      expect(Validator.between_min_max?(10, 1, max.sample)).to be true
    end 

    it 'skips validation returning a true because min/max values are not present' do
      expect(Validator.between_min_max?(100, nil, nil)).to be true
    end 

    it 'between min and max' do
      expect(Validator.between_min_max?(10, 1, 20)).to be true
    end 

    it 'not between min and max' do
      expect(Validator.between_min_max?(8, 15, 20)).to be false
    end 
  end 

  context '.integer_spaces' do
    it 'valid string' do
      expect(Validator.integer_spaces('300000')).to be true
    end
    it 'valid int' do
      expect(Validator.integer_spaces(3000)).to be true
    end
    it 'valid float' do
      expect(Validator.integer_spaces(3.08345)).to be true
    end
    it 'valid string - space' do
      expect(Validator.integer_spaces('30000 000')).to be true
    end
    it 'valid trailing space and starting space' do
      expect(Validator.integer_spaces(' 30000 ')).to be true
    end 
    it 'valid with start, trailing, and middle space' do
      expect(Validator.integer_spaces(' 300 000 ')).to be true
    end 
    it 'valid with trailing space' do
      expect(Validator.integer_spaces('30000 ')).to be true
    end 
    it 'valid with starting space' do
      expect(Validator.integer_spaces(' 30000')).to be true
    end 
    it 'not valid number - letter' do
      expect(Validator.integer_spaces('3000a')).to be false
    end
    it 'not valid - strings' do
      expect(Validator.integer_spaces('testing')).to be false
    end
  end

  context '.alpha_numeric' do
    it 'does not like scripty shenanigans' do
      str = "Somealpha823stuff\n<script>alert('pwned')</script>"
      expect(Validator.alpha_numeric(str)).to be false
    end
    it 'does not like other characters' do
      str = 'Some!_.asdf;'
      expect(Validator.alpha_numeric(str)).to be false
    end 
    it 'likes alphabets with spaces' do
      str = 'AlphaNumerical0003754'
      expect(Validator.alpha_numeric(str)).to be true
    end
    it 'likes numerical' do
      str = '8234985'
      expect(Validator.alpha_numeric(str)).to be true
    end
  end

  context '.alpha_numeric_spaces' do
    it 'does not like scripty shenanigans' do
      str = "Some alpha 823 stuff\n<script>alert('pwned')</script>"
      expect(Validator.alpha_numeric_spaces(str)).to be false 
    end
    it 'does not like other characters' do
      str = 'Some alpha numerical with punctuation.'
      expect(Validator.alpha_numeric_spaces(str)).to be false
    end 
    it 'likes alphabets with spaces' do
      str = 'Alpha Numerical stuff'
      expect(Validator.alpha_numeric_spaces(str)).to be true 
    end
    it 'likes alpha and numerical stuff' do
      str = 'Cat20485'
      expect(Validator.alpha_numeric_spaces(str)).to be true
    end 
    it 'likes alph numerical with spaces' do
      str = 'Cat Number 12945'
      expect(Validator.alpha_numeric_spaces(str)).to be true
    end 
    it 'likes numerical' do
      str = '8234985'
      expect(Validator.alpha_numeric_spaces(str)).to be true
    end
  end

  context '.alpha' do
    it 'hates alpha with spaces' do
      expect(Validator.alpha('something cool spaces')).to be false
    end
    it 'likes all alpha with no spaces' do
      expect(Validator.alpha('somethingCoolMan')).to be true
    end
    it 'hates punctuation marks' do
      expect(Validator.alpha('somethingcool.')).to be false
    end
    it 'hates numbers' do
      expect(Validator.alpha('idonotlikenumbers284')).to be false
    end
  end

  context '.alpha_spaces' do
    it 'like all alpha with spaces' do
      expect(Validator.alpha_spaces('something cool spaces')).to be true
    end
    it 'likes all alpha with no spaces' do
      expect(Validator.alpha_spaces('somethingCoolMan')).to be true
    end
    it 'hates punctuation marks' do
      expect(Validator.alpha_spaces('somethingcool.')).to be false
    end
    it 'hates numbers' do
      expect(Validator.alpha_spaces('idonotlikenumbers284')).to be false
    end
  end

  context '.no_special_chars' do
    chars = '!@#$%^&*()_+{}|:">?<[]\\\';,.`~µñ©æáßðøäåé®þüúíóö'
    char_array = chars.split('')
    char_array.each do |char|
      it "does not like #{char} as a character" do
        expect(Validator.no_special_chars("testing#{char}")).to be false
      end
    end

    it 'likes this because no special characters' do
      expect(Validator.no_special_chars('testing something')).to be true
    end
  end

  context '.date' do
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
        expect(Validator.date(e)).to be true
      end
    end

    invalid_edtf = [
      'joes',
      '1800jdks',
      '1991/32/32'
    ]
    invalid_edtf.each do |e|
      it "does not validate edtf - #{e}" do
        expect(Validator.date(e)).to be false
      end
    end

    
    context '.no_spaces' do
      it 'should return false the string has spaces' do
        str = ' sme string with spaces '
        expect(Validator.no_spaces(str)).to be false 
      end
      
      it 'should return true the string has no spaces' do
        str = 'as;dlfkjas;dflkjasd;lfkjasd;f'
        expect(Validator.no_spaces(str)).to be true
      end
    end
  end
end