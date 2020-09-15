require "rails_helper"

RSpec.describe Items::DigitalObjectsController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(get: "/items/digital_objects").to route_to("items/digital_objects#index")
    end

    it "routes to #new" do
      expect(get: "/items/digital_objects/new").to route_to("items/digital_objects#new")
    end

    it "routes to #show" do
      expect(get: "/items/digital_objects/1").to route_to("items/digital_objects#show", id: "1")
    end

    it "routes to #edit" do
      expect(get: "/items/digital_objects/1/edit").to route_to("items/digital_objects#edit", id: "1")
    end


    it "routes to #create" do
      expect(post: "/items/digital_objects").to route_to("items/digital_objects#create")
    end

    it "routes to #update via PUT" do
      expect(put: "/items/digital_objects/1").to route_to("items/digital_objects#update", id: "1")
    end

    it "routes to #update via PATCH" do
      expect(patch: "/items/digital_objects/1").to route_to("items/digital_objects#update", id: "1")
    end

    it "routes to #destroy" do
      expect(delete: "/items/digital_objects/1").to route_to("items/digital_objects#destroy", id: "1")
    end
  end
end
