# frozen_string_literal: true

require 'rails_helper'

RSpec.describe MembersController, type: :controller do
  let(:member) { create :member }

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
    let(:member_params) { attributes_for :member, cash_register_proficiency: 'proficient' }

    before {
      put :update, params: { id: member.id, member: member_params }
    }

    %i(
      first_name last_name biography phone_number cash_register_proficiency
    ).each do |attribute|
      it "changes the #{attribute} attribute" do
        expect(member.reload.send(attribute)).to eq member_params[attribute]
      end
    end

    context "when updating the address" do
      let(:address) { create :member_address, member: member }
      let(:address_params) { attributes_for :address }

      before {
        put :update, params: { id: member.id, member: { address_attributes: address_params } }
      }

      %i(city postal_code street_name_1 street_name_2).each do |attribute|
        it "changes the nested address #{attribute} attributes" do
          expect(member.reload.address.send(attribute)).to eq address_params[attribute]
        end
      end
    end

    it "sets a confirmation message" do
      expect(flash[:notice]).to eq(I18n.translate("activerecord.notices.messages.update_success"))
    end
  end
end
