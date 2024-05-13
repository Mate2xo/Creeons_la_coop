require 'rails_helper'

RSpec.describe 'Admin::Groups' do
  before { sign_in build_stubbed(:member, :super_admin) }

  describe 'GET /admin/groups' do
    subject(:index) do
      create_list(:group, 1)
      get admin_groups_path
    end

    it 'has an :ok HTTP status' do
      index
      expect(response).to have_http_status(:ok)
    end
  end

  describe 'GET /admin/groups/:id' do
    subject(:show) { get admin_group_path(group) }

    let(:group) { create(:group, :with_members_and_managers) }

    it 'has an :ok HTTP status' do
      show
      expect(response).to have_http_status(:ok)
    end
  end

  describe 'GET /admin/groups/new' do
    subject(:new) { get new_admin_group_path }

    it 'has an :ok HTTP status' do
      new
      expect(response).to have_http_status(:ok)
    end
  end

  describe 'GET /admin/groups/:id/edit' do
    subject(:edit) { get edit_admin_group_path(group) }

    let(:group) { create(:group) }

    it 'has an :ok HTTP status' do
      edit
      expect(response).to have_http_status(:ok)
    end
  end
end
