require 'rails_helper'

RSpec.describe Validator, type: :model do
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

    it 'valid varients' do
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
        expect(Validator.phone_number(n)).to be true
      end
    end

    it 'invalid varients' do
      invalid_numbers = [ 
        '123.234.123', 
        'joe', 
        '123-234-1234x',
        '1-230-234-2356x'
      ]
      invalid_numbers.each do |n|
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
      expect(Validator.limit_words(Faker::Lorem.sentence(8), 10)).to be true
    end

    it 'string has equal words than the limit' do
      test_string = 'Some words that have one-way hyphens and stuff.'
      expect(Validator.limit_words(test_string, 8)).to be true
    end

    it 'equal to limit - automated string' do
      expect(Validator.limit_words(Faker::Lorem.sentence(10), 10)).to be true
    end

    it 'more than limit - manual string' do
      test_string = 'Some words that have one-way hyphens and stuff.'
      expect(Validator.limit_words(test_string, 3)).to be false
    end

    it 'more than limit - automated string' do
      expect(Validator.limit_words(Faker::Lorem.sentence(12), 3)).to be false
    end
  end

  context '.limit_chars' do
    it 'less than limit' do
      expect(Validator.limit_chars(Faker::Lorem.characters(4), 10)).to be true
    end

    it 'equal to limit' do
      expect(Validator.limit_chars(Faker::Lorem.characters(8), 8)).to be true
    end

    it 'more than limit' do
      expect(Validator.limit_chars(Faker::Lorem.characters(12), 7)).to be false
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
    it 'not valid number - letter' do
      expect(Validator.integer_spaces('3000a')).to be false
    end
    it 'not valid - strings' do
      expect(Validator.integer_spaces('testing')).to be false
    end 
  end
end