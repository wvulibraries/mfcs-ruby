RSpec.shared_examples "a validator object" do
  context 'methods' do
    before(:each) do
      @base =  described_class.new({'testing': 'soemthing here'}, 'test_input', 1)
    end
    
    it 'should respond to the perform method' do
      expect(@base).respond_to? :perform
    end 

    it 'should have field_info instance variable' do
      expect(@base.instance_variable_defined?(:@field_info)).to be true
    end 

    it 'should have input as an instance variable' do
      expect(@base.instance_variable_defined?(:@input)).to be true
    end 

    it 'should have form_id as an instance variable' do
      expect(@base.instance_variable_defined?(:@form_id)).to be true
    end 
  end
end