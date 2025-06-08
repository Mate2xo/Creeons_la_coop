require 'rails_helper'

RSpec.describe 'admin/productors' do
  before { sign_in build_stubbed(:member, :super_admin) }

  describe 'GET /' do
    subject(:index) { create_list(:group, 2) and get admin_productors_path }

    it 'has an :ok HTTP status' do
      index
      expect(response).to have_http_status(:ok)
    end
  end

  describe 'GET /:id' do
    subject(:show) { get admin_productor_path(productor) }

    let(:productor) { create(:productor) }

    it 'has an :ok HTTP status' do
      show
      expect(response).to have_http_status(:ok)
    end
  end

  describe 'GET /new' do
    subject(:new) { get new_admin_productor_path }

    it 'has an :ok HTTP status' do
      new
      expect(response).to have_http_status(:ok)
    end
  end

  describe 'GET /edit' do
    subject(:edit) { get edit_admin_productor_path(productor) }

    let(:productor) { create(:productor) }

    it 'has an :ok HTTP status' do
      edit
      expect(response).to have_http_status(:ok)
    end
  end
end
