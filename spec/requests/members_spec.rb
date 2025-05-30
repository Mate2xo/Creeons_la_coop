# frozen_string_literal: true

require 'rails_helper'

RSpec.describe '/members' do
  let(:member) { create(:member) }

  before { sign_in member }

  describe 'GET /' do
    subject(:index) { create_list(:member, 2) and get members_path }

    it 'has an HTTP :OK status' do
      index
      expect(response).to have_http_status(:ok)
    end
  end

  describe 'GET /:id' do
    subject(:show) { get member_path(member) }

    let(:member) { create(:member) }

    it 'has an HTTP :OK status' do
      show
      expect(response).to have_http_status(:ok)
    end
  end

  describe 'GET /:id/edit' do
    subject(:edit) { get edit_member_path(member) }

    let(:member) { create(:member) }

    it 'has an HTTP :OK status' do
      edit
      expect(response).to have_http_status(:ok)
    end
  end

  describe 'PUT /:id' do
    subject(:put_member) { put member_path(member.id), params: {member: member_params} }

    context 'without static slots selection' do
      let(:member_params) { {first_name: 'updated_member', last_name: 'tati'} }

      it 'update successfully' do
        put_member

        member_params.each do |key, value|
          expect(member.reload.attributes[key.to_s]).to eq value
        end
      end
    end

    context 'with static slots selection' do
      let(:static_slot1) { create(:static_slot) }
      let(:static_slot2) { create(:static_slot) }
      let(:member_params) do
        {first_name: 'updated_member',
         last_name: 'tati',
         static_slots_attributes: {'1564': {id: static_slot1.id.to_s, _destroy: false},
                                   '65464': {id: static_slot2.id.to_s, _destroy: false}}}
      end

      it 'update successfully' do
        put_member

        member_params.each do |key, value|
          next if key == :static_slots_attributes

          expect(member.reload.attributes[key.to_s]).to eq value
        end
      end

      it 'gives static_slots to the member' do
        expect { put_member }.to change { member.reload.static_slots.count }.by(2)
      end
    end
  end
end
