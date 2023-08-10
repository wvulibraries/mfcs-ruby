require 'rails_helper'

RSpec.describe FieldBuilder::Variable, type: :model do
  let(:user) {  FactoryBot.create(:user, :admin) }

  context '.vars?' do
    it 'should return an array of all variables in the string' do
      test_string = "contains no variables %"
      vars = FieldBuilder::Variable.vars?(test_string)
      expect(vars).to be_in([true, false])
      expect(vars).to be false
    end 

    it 'should contain the proper amount of variables if variables are side by side.' do
      test_string = "contains no variables %date% %firstname% %lastname%"
      vars = FieldBuilder::Variable.vars?(test_string)
      expect(vars).to be_in([true, false])
      expect(vars).to be true
    end 

    it 'should contain multiple variables' do
      test_string = "%firstname% contains %date% no variables %lastname%"
      vars = FieldBuilder::Variable.vars?(test_string)
      puts vars.inspect 
      expect(vars).to be_in([true, false])
      expect(vars).to be true
    end 

    it 'should contain a single variable.' do
      test_string = "%lastname% something should change here"
      vars = FieldBuilder::Variable.vars?(test_string)
      expect(vars).to be_in([true, false])
      expect(vars).to be true
    end 
  end

  context '.sub_vars' do
    it 'should change all variables in the string' do
      test_str = "%date% %time% %timestamp% %time12% %time24% %username% %firstname% %lastname%"
      replaced = FieldBuilder::Variable.sub_vars(test_str, user)
      expect(replaced).to_not include('%date%')
      expect(replaced).to_not include('%time%')
      expect(replaced).to_not include('%time12%')
      expect(replaced).to_not include('%time24%')
      expect(replaced).to_not include('%timestamp%')
      expect(replaced).to_not include('%firstname%')
      expect(replaced).to_not include('%lastname%')
      expect(replaced).to_not include('%username%')
    end

    it 'should change everything including the custom date' do
      test_str = "%date% %time% %timestamp% %time12% %time24% %username% %firstname% %lastname% %date('%Y/%m/%d')%"
      replaced = FieldBuilder::Variable.sub_vars(test_str, user)
      expect(replaced).to_not include('%date%')
      expect(replaced).to_not include('%time%')
      expect(replaced).to_not include('%time12%')
      expect(replaced).to_not include('%time24%')
      expect(replaced).to_not include('%timestamp%')
      expect(replaced).to_not include('%firstname%')
      expect(replaced).to_not include('%lastname%')
      expect(replaced).to_not include('%username%')
      expect(replaced).to_not include("%date('%Y/%m/%d')%")
    end
  end

  context '.custom_date?' do
    it 'should not contain a custom date' do
      test_str = "%date% %time% %timestamp% %time12% %time24% %username% %firstname% %lastname%"
      expect(FieldBuilder::Variable.custom_date?(test_str)).to be_in([true, false])
      expect(FieldBuilder::Variable.custom_date?(test_str)).to be false
    end

    it 'should contain a custom date' do
      test_str = "%date% %time% %timestamp% %time12% %time24% %username% %firstname% %lastname% %date('%Y/%m/%d')%"
      expect(FieldBuilder::Variable.custom_date?(test_str)).to be_in([true, false])
      expect(FieldBuilder::Variable.custom_date?(test_str)).to be true
    end
  end 

  context '.parse_custom_date' do
    it 'parses the corrected string date format' do
      test_str = "%date('%Y/%m/%d')%"
      expect(FieldBuilder::Variable.parse_custom_date(test_str)).to_not include(test_str)
      expect(FieldBuilder::Variable.parse_custom_date(test_str)).to eq Time.now.strftime('%Y/%m/%d')
    end

    it 'parses the corrected string date format' do
      test_str = "%date('')%"
      expect(FieldBuilder::Variable.parse_custom_date(test_str)).to_not include(test_str)
      expect(FieldBuilder::Variable.parse_custom_date(test_str)).to eq ''
    end
  end 

end