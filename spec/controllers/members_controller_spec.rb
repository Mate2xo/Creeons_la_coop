# frozen_string_literal: true

require 'rails_helper'

RSpec.describe MembersController, type: :controller do
  describe "Member update" do
    let(:member) { create :member }

    context "when a member updates his address on his profile" do
      let(:address) { create :member_address, member: member }

      before {
        sign_in member
        address
      }

      it "changes the nested address attributes" do
        address_params = attributes_for :address
        put :update, params: { id: member.id, member: { address_attributes: address_params } }
        expect(member.reload.address.city).to eq address_params[:city]
        expect(member.reload.address.postal_code).to eq address_params[:postal_code]
        expect(member.reload.address.street_name_1).to eq address_params[:street_name_1]
        expect(member.reload.address.coordonnee).to eq address_params[:coordonnee]
      end
    end
  end
end
