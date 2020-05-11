require "rails_helper"

RSpec.describe "Routes for Forms API", :type => :routing do
  context 'routable links' do
    it "/api/v1/form/:id" do
      expect(:get => "/api/v1/form/1").to be_routable
    end

    it "/api/v1/form" do
      expect(:get => "/api/v1/form").to be_routable
    end

    it "/api/v1/forms" do
      expect(:get => "/api/v1/forms").to be_routable
    end

    it "/api/v1/forms/metadata" do
      expect(:get => "/api/v1/forms/metadata").to be_routable
    end

    it "/api/v1/forms/metadata/names" do
      expect(:get => "/api/v1/forms/metadata/names").to be_routable
    end

    it "/api/v1/form/:id/fields" do
      expect(:get => "/api/v1/form/1/fields").to be_routable
    end
  end 
end