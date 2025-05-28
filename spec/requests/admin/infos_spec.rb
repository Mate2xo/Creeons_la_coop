# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'admin/infos' do
  before { sign_in admin }

  let(:admin) { build_stubbed(:member, :super_admin) }

  describe 'GET /' do
    subject(:index) { create_list(:info, 2) and get admin_infos_path }

    it 'has an :ok HTTP status' do
      index
      expect(response).to have_http_status(:ok)
    end
  end

  describe 'GET /new' do
    subject(:new) { get new_admin_info_path }

    let(:admin) { create(:member, :super_admin) }

    it 'has an :ok HTTP status' do
      new
      expect(response).to have_http_status(:ok)
    end
  end

  describe 'GET /:id' do
    subject(:show) { get admin_info_path(info) }

    let(:info) { create(:info) }

    it 'has an :ok HTTP status' do
      show
      expect(response).to have_http_status(:ok)
    end
  end

  describe 'GET /:id/edit' do
    subject(:edit) { get edit_admin_info_path(info) }

    let(:info) { create(:info) }

    it 'has an :ok HTTP status' do
      edit
      expect(response).to have_http_status(:ok)
    end
  end
end
