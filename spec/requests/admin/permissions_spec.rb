 require 'rails_helper'
RSpec.describe "/permissions", type: :request do
  # Watermark. As you add validations to Watermark, be sure to
  # adjust the attributes here as well.
  let(:admin) { FactoryBot.create :user, :admin }
  let(:valid_attributes) { FactoryBot.attributes_for :permission } 
  let(:invalid_attributes) { FactoryBot.attributes_for :user }

  before(:each) do
    sign_in admin
  end

  describe "GET /index" do
    it "renders a successful response" do
      Permission.create! valid_attributes
      get admin_permissions_url
      expect(response).to be_successful
    end
  end

  describe "GET /show" do
    it "renders a successful response" do
      permission = Permission.create! valid_attributes
      get admin_permission_url(permission)
      expect(response).to be_successful
    end
  end

  describe "GET /new" do
    it "renders a successful response" do
      get new_admin_permission_url
      expect(response).to be_successful
    end
  end

  describe "GET /edit" do
    it "render a successful response" do
      permission = Permission.create! valid_attributes
      get edit_admin_permission_url(permission)
      expect(response).to be_successful
    end
  end

  describe "POST /create" do
    context "with valid parameters" do
      it "creates a new Permission" do
        expect {
          post admin_permissions_url, params: { admin_permission: valid_attributes }
        }.to change(Permission, :count).by(1)
      end

      it "redirects to the created admin_permission" do
        post admin_permissions_url, params: { admin_permission: valid_attributes }
        expect(response).to redirect_to(admin_permission_url(Permission.last))
      end
    end

    context "with invalid parameters" do
      it "does not create a new Permission" do
        expect {
          post admin_permissions_url, params: { admin_permission: invalid_attributes }
        }.to change(Permission, :count).by(0)
      end

      it "renders a successful response (i.e. to display the 'new' template)" do
        post admin_permissions_url, params: { admin_permission: invalid_attributes }
        expect(response).to be_successful
      end
    end
  end

  describe "PATCH /update" do
    context "with valid parameters" do
      let(:new_attributes) {
        skip("Add a hash of attributes valid for your model")
      }

      it "updates the requested admin_permission" do
        permission = Permission.create! valid_attributes
        patch admin_permission_url(permission), params: { permission: new_attributes }
        permission.reload
        skip("Add assertions for updated state")
      end

      it "redirects to the admin_permission" do
        permission = Permission.create! valid_attributes
        patch admin_permission_url(permission), params: { permission: new_attributes }
        permission.reload
        expect(response).to redirect_to(permission_url(permission))
      end
    end

    context "with invalid parameters" do
      it "renders a successful response (i.e. to display the 'edit' template)" do
        permission = Permission.create! valid_attributes
        patch admin_permission_url(permission), params: { permission: invalid_attributes }
        expect(response).to be_successful
      end
    end
  end

  describe "DELETE /destroy" do
    it "destroys the requested admin_permission" do
      permission = Permission.create! valid_attributes
      expect {
        delete admin_permission_url(permission)
      }.to change(Permission, :count).by(-1)
    end

    it "redirects to the permissions list" do
      permission = Permission.create! valid_attributes
      delete admin_permission_url(permission)
      expect(response).to redirect_to(admin_permissions_url)
    end
  end
end
