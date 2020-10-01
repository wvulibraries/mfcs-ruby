require 'rails_helper'

RSpec.describe Validator::Base, type: :model do
  # shared examples
  context 'base behaviors' do
    it_behaves_like 'a validator' 
  end
end 