require 'rails_helper'

RSpec.describe "/cleaning_foreign_body_checks", type: :request do
  let!(:staff) { create(:staff, employment_status: "Active", dept: "Cheesemaking Team") }

  let(:valid_attributes) {
    {
      date: Date.today,
      milk_pipeline: true,
      staff_id: staff.id
    }
  }

  let(:invalid_attributes) {
    {
      date: nil, # date is required
      milk_pipeline: true,
      staff_id: nil
    }
  }

  let(:new_attributes) {
    {
      milk_pipeline: false,
      cheese_vat: true
    }
  }

  describe "GET /index" do
    it "renders a successful response" do
      CleaningForeignBodyCheck.create! valid_attributes
      get cleaning_foreign_body_checks_url
      expect(response).to be_successful
    end
  end

  describe "GET /show" do
    it "renders a successful response" do
      cleaning_foreign_body_check = CleaningForeignBodyCheck.create! valid_attributes
      get cleaning_foreign_body_check_url(cleaning_foreign_body_check)
      expect(response).to be_successful
    end
  end

  describe "GET /new" do
    it "renders a successful response" do
      get new_cleaning_foreign_body_check_url
      expect(response).to be_successful
    end
  end

  describe "GET /edit" do
    it "renders a successful response" do
      cleaning_foreign_body_check = CleaningForeignBodyCheck.create! valid_attributes
      get edit_cleaning_foreign_body_check_url(cleaning_foreign_body_check)
      expect(response).to be_successful
    end
  end

  describe "POST /create" do
    context "with valid parameters" do
      it "creates a new CleaningForeignBodyCheck" do
        expect {
          post cleaning_foreign_body_checks_url, params: { cleaning_foreign_body_check: valid_attributes }
        }.to change(CleaningForeignBodyCheck, :count).by(1)
      end

      it "redirects to the created cleaning_foreign_body_check" do
        post cleaning_foreign_body_checks_url, params: { cleaning_foreign_body_check: valid_attributes }
        expect(response).to redirect_to(cleaning_foreign_body_check_url(CleaningForeignBodyCheck.last))
      end
    end

    context "with invalid parameters" do
      it "does not create a new CleaningForeignBodyCheck" do
        expect {
          post cleaning_foreign_body_checks_url, params: { cleaning_foreign_body_check: invalid_attributes }
        }.to change(CleaningForeignBodyCheck, :count).by(0)
      end

      it "renders a response with 422 status (i.e. to display the 'new' template)" do
        post cleaning_foreign_body_checks_url, params: { cleaning_foreign_body_check: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe "PATCH /update" do
    context "with valid parameters" do
      it "updates the requested cleaning_foreign_body_check" do
        cleaning_foreign_body_check = CleaningForeignBodyCheck.create! valid_attributes
        patch cleaning_foreign_body_check_url(cleaning_foreign_body_check), params: { cleaning_foreign_body_check: new_attributes }
        cleaning_foreign_body_check.reload
        expect(cleaning_foreign_body_check.cheese_vat).to eq(true)
      end

      it "redirects to the cleaning_foreign_body_check" do
        cleaning_foreign_body_check = CleaningForeignBodyCheck.create! valid_attributes
        patch cleaning_foreign_body_check_url(cleaning_foreign_body_check), params: { cleaning_foreign_body_check: new_attributes }
        expect(response).to redirect_to(cleaning_foreign_body_check_url(cleaning_foreign_body_check))
      end
    end

    context "with invalid parameters" do
      it "renders a response with 422 status (i.e. to display the 'edit' template)" do
        cleaning_foreign_body_check = CleaningForeignBodyCheck.create! valid_attributes
        patch cleaning_foreign_body_check_url(cleaning_foreign_body_check), params: { cleaning_foreign_body_check: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe "DELETE /destroy" do
    it "destroys the requested cleaning_foreign_body_check" do
      cleaning_foreign_body_check = CleaningForeignBodyCheck.create! valid_attributes
      expect {
        delete cleaning_foreign_body_check_url(cleaning_foreign_body_check)
      }.to change(CleaningForeignBodyCheck, :count).by(-1)
    end

    it "redirects to the cleaning_foreign_body_checks list" do
      cleaning_foreign_body_check = CleaningForeignBodyCheck.create! valid_attributes
      delete cleaning_foreign_body_check_url(cleaning_foreign_body_check)
      expect(response).to redirect_to(cleaning_foreign_body_checks_url)
    end
  end
end
