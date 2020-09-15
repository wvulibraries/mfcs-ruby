require "rails_helper"

RSpec.describe Items::MetadataController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(get: "/items/metadata").to route_to("items/metadata#index")
    end

    it "routes to #new" do
      expect(get: "/items/metadata/new").to route_to("items/metadata#new")
    end

    it "routes to #show" do
      expect(get: "/items/metadata/1").to route_to("items/metadata#show", id: "1")
    end

    it "routes to #edit" do
      expect(get: "/items/metadata/1/edit").to route_to("items/metadata#edit", id: "1")
    end


    it "routes to #create" do
      expect(post: "/items/metadata").to route_to("items/metadata#create")
    end

    it "routes to #update via PUT" do
      expect(put: "/items/metadata/1").to route_to("items/metadata#update", id: "1")
    end

    it "routes to #update via PATCH" do
      expect(patch: "/items/metadata/1").to route_to("items/metadata#update", id: "1")
    end

    it "routes to #destroy" do
      expect(delete: "/items/metadata/1").to route_to("items/metadata#destroy", id: "1")
    end
  end
end
