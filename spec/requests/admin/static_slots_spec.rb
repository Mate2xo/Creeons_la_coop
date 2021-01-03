# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'A StaticSlot request', type: :request do
  before { sign_in create :member, :super_admin }

  describe 'GET index' do
    it 'has a successful response' do
      create_list :static_slot, 4

      get admin_static_slots_path

      expect(response).to be_successful
    end
  end

  describe 'GET show' do
    subject(:get_show) { get admin_static_slot_path(static_slot.id) }

    let(:static_slot) { create :static_slot }

    it 'has a successful response' do
      attribute_static_slot_to_n_members(static_slot, 4)

      get_show

      expect(response).to be_successful
    end

    it 'displays a panel with members' do
      members = attribute_static_slot_to_n_members(static_slot, 4)

      get_show

      expect(response.body).to include(members[0].first_name).and include(members[1].first_name)
        .and include(members[2].first_name)
    end
  end

  describe 'GET new' do
    it 'has a successful response' do
      get new_admin_static_slot_path

      expect(response).to be_successful
    end
  end

  describe 'POST StaticSlot' do
    subject(:post_static_slot) do
      post admin_static_slots_path,
           params: { static_slot: static_slot_params }
    end

    let(:static_slot_params) { attributes_for :static_slot }

    it 'creates a static_slot with success' do
      expect { post_static_slot }.to change(StaticSlot, :count).by(1)
    end
  end

  describe 'GET edit' do
    subject(:get_edit) { get admin_static_slot_path(static_slot.id) }

    let(:static_slot) { create :static_slot }

    it 'has a successful response' do
      get_edit

      expect(response).to be_successful
    end
  end

  describe 'PUT StaticSlot' do
    subject(:put_static_slot) do
      put admin_static_slot_path(static_slot.id),
          params: { static_slot: static_slot_params }
    end

    let(:static_slot_params) { attributes_for :static_slot, week_type: 'D' }
    let(:static_slot) { create :static_slot }

    it 'updates a static_slot with success' do
      put_static_slot

      expect(StaticSlot.find(static_slot.id).week_type).to eq 'D'
    end
  end

  describe 'DELETE StaticSlot' do
    subject(:delete_static_slot) do
      delete admin_static_slot_path(static_slot.id), params: { static_slot: { id: static_slot.id } }
    end

    let(:static_slot) { create :static_slot }

    it 'deletes' do
      delete_static_slot

      expect(StaticSlot.find_by(id: static_slot.id)).to be_nil
    end

    it 'removes association with related members' do
      members = attribute_static_slot_to_n_members(static_slot, 4)

      delete_static_slot

      expect(members.map(&:static_slots)).to all(be_empty)
    end
  end

  def attribute_static_slot_to_n_members(static_slot, members_count = 4)
    members = create_list :member, members_count
    members.each do |member|
      create :member_static_slot, member: member, static_slot: static_slot
    end
  end
end
