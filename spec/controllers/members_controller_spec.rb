# frozen_string_literal: true

require 'rails_helper'

RSpec.describe MembersController, type: :controller do
  let(:member) { create :member }

  context "as a member" do
    before { sign_in member }

    describe "GET index" do
      before { get :index }

      it { expect(response).to have_http_status(:success) }
      it { expect(assigns(:members)).to include(member) }
    end

    describe "GET show" do
      before { get :show, params: { id: member.id } }

      it { expect(response).to have_http_status :success }
      it { expect(assigns(:member)).to eq(member) }
    end

    describe "GET edit on a member's own profile" do
      before { get :edit, params: { id: member.id } }

      it { expect(response).to have_http_status :success }
      it { expect(assigns(:member)).to eq(member) }
    end

    describe "PUT #update, member updating his own profile" do
      let!(:address) { create :member_address, member: member }
      let(:address_params) { attributes_for :address }
      let(:request) { put :update, params: { id: member.id, member: { address_attributes: address_params } } }

      before { request }

      it "changes the nested address attributes" do
        expect(member.reload.address.city).to eq address_params[:city]
        expect(member.reload.address.postal_code).to eq address_params[:postal_code]
        expect(member.reload.address.street_name_1).to eq address_params[:street_name_1]
      end

      it "sets a confirmation message" do
        expect(flash[:notice]).to eq I18n.t("main_app.model.update.ok")
      end
    end

    describe "authorizations" do
      let(:other_member) { create :member }

      it "does not allow edition of another member" do
        expect(get(:edit, params: { id: other_member.id })).to redirect_to(root_path)
      end

      it "does not allow update of another member" do
        expect(post(:update, params: {
                      id: other_member.id,
                      member: attributes_for(:member)
                    })).to redirect_to(root_path)
      end
    end
  end
end
