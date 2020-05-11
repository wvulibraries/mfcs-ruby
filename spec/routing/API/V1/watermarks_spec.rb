require "rails_helper"

RSpec.describe "Routes for Forms API", :type => :routing do
  context 'routable links' do
    it "/api/v1/watermarks" do
      expect(:get => "/api/v1/watermarks").to be_routable
    end
  end 
end