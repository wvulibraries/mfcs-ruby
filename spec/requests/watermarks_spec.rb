 require 'rails_helper'

RSpec.describe "/admin/watermarks", type: :request do
  # Watermark. As you add validations to Watermark, be sure to
  # adjust the attributes here as well.
  let(:admin) { FactoryBot.create :user, :admin }
  let(:valid_attributes) { FactoryBot.attributes_for :watermark } 

  # let(:invalid_attributes) {
  #   { :name => 'Something Name', :funky_test => '' }
  # }

  describe "GET /index" do
    it "renders a successful response" do
      sign_in admin
      #Watermark.create! valid_attributes
      get '/admin/watermarks'
      expect(response).to be_successful
    end
  end



  # describe "GET /edit" do
  #   it "render a successful response" do
  #     watermark = Watermark.create! valid_attributes
  #     get edit_admin_watermark_url(watermark)
  #     expect(response).to be_successful
  #   end
  # end

  # describe "POST /create" do
  #   context "with valid parameters" do
  #     it "creates a new Watermark" do
  #       expect {
  #         post admin_watermarks_url, params: { watermark: valid_attributes }
  #       }.to change(Watermark, :count).by(1)
  #     end

  #     it "redirects to the created watermark" do
  #       post admin_watermarks_url, params: { watermark: valid_attributes }
  #       expect(response).to redirect_to(admin_watermark_url(Watermark.last))
  #     end
  #   end

  #   context "with invalid parameters" do
  #     it "does not create a new Watermark" do
  #       expect {
  #         post admin_watermarks_url, params: { watermark: invalid_attributes }
  #       }.to change(Watermark, :count).by(0)
  #     end

  #     it "renders a successful response (i.e. to display the 'new' template)" do
  #       post admin_watermarks_url, params: { watermark: invalid_attributes }
  #       expect(response).to be_successful
  #     end
  #   end
  # end

  # describe "PATCH /update" do
  #   context "with valid parameters" do
  #     let(:new_attributes) {
  #       skip("Add a hash of attributes valid for your model")
  #     }

  #     it "updates the requested watermark" do
  #       watermark = Watermark.create! valid_attributes
  #       patch admin_watermark_url(watermark), params: { watermark: new_attributes }
  #       watermark.reload
  #       skip("Add assertions for updated state")
  #     end

  #     it "redirects to the watermark" do
  #       watermark = Watermark.create! valid_attributes
  #       patch admin_watermark_url(watermark), params: { watermark: new_attributes }
  #       watermark.reload
  #       expect(response).to redirect_to(admin_watermark_url(watermark))
  #     end
  #   end

  #   context "with invalid parameters" do
  #     it "renders a successful response (i.e. to display the 'edit' template)" do
  #       watermark = Watermark.create! valid_attributes
  #       patch admin_watermark_url(watermark), params: { watermark: invalid_attributes }
  #       expect(response).to be_successful
  #     end
  #   end
  # end

  # describe "DELETE /destroy" do
  #   it "destroys the requested watermark" do
  #     watermark = Watermark.create! valid_attributes
  #     expect {
  #       delete admin_watermark_url(watermark)
  #     }.to change(Watermark, :count).by(-1)
  #   end

  #   it "redirects to the watermarks list" do
  #     watermark = Watermark.create! valid_attributes
  #     delete admin_watermark_url(watermark)
  #     expect(response).to redirect_to(admin_watermarks_url)
  #   end
  # end
end
