require "rails_helper"

RSpec.describe Admin::WatermarksController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(get: "/admin/watermarks").to route_to("admin/watermarks#index")
    end

    it "routes to #edit" do
      expect(get: "/admin/watermarks/1/edit").to route_to("admin/watermarks#edit", id: "1")
    end


    it "routes to #create" do
      expect(post: "/admin/watermarks").to route_to("admin/watermarks#create")
    end

    it "routes to #update via PUT" do
      expect(put: "/admin/watermarks/1").to route_to("admin/watermarks#update", id: "1")
    end

    it "routes to #update via PATCH" do
      expect(patch: "/admin/watermarks/1").to route_to("admin/watermarks#update", id: "1")
    end

    it "routes to #destroy" do
      expect(delete: "/admin/watermarks/1").to route_to("admin/watermarks#destroy", id: "1")
    end
  end
end
 