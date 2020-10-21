require 'rails_helper'

RSpec.describe Validator::IpAddr, type: :model do
  # shared examples
  context 'base behaviors' do
    it_behaves_like 'a validator object' 
  end

  it_behaves_like 'a ip class'
end 