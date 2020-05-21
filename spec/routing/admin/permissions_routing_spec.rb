require "rails_helper"

RSpec.describe Admin::PermissionsController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(get: "/admin/permissions").to route_to("admin/permissions#index")
    end

    it "routes to #new" do
      expect(get: "/admin/permissions/new").to route_to("admin/permissions#new")
    end

    it "routes to #show" do
      expect(get: "/admin/permissions/1").to route_to("admin/permissions#show", id: "1")
    end

    it "routes to #edit" do
      expect(get: "/admin/permissions/1/edit").to route_to("admin/permissions#edit", id: "1")
    end


    it "routes to #create" do
      expect(post: "/admin/permissions").to route_to("admin/permissions#create")
    end

    it "routes to #update via PUT" do
      expect(put: "/admin/permissions/1").to route_to("admin/permissions#update", id: "1")
    end

    it "routes to #update via PATCH" do
      expect(patch: "/admin/permissions/1").to route_to("admin/permissions#update", id: "1")
    end

    it "routes to #destroy" do
      expect(delete: "/admin/permissions/1").to route_to("admin/permissions#destroy", id: "1")
    end
  end
end
