require 'rails_helper'

RSpec.describe 'Admin::Documents' do
  before { sign_in build_stubbed(:member, :super_admin) }

  describe 'GET /admin/documents' do
    subject(:index) do
      create(:document)
      create(:document, file: fixture_file_upload('test.txt'))
      get admin_documents_path
    end

    it 'has an :ok HTTP status' do
      index
      expect(response).to have_http_status(:ok)
    end
  end

  describe 'GET /admin/documents/new' do
    subject(:new) { get new_admin_document_path }

    it 'has an :ok HTTP status' do
      new
      expect(response).to have_http_status(:ok)
    end
  end

  describe 'GET /admin/documents/:id/edit' do
    subject(:edit) { get edit_admin_document_path(create(:document)) }

    it 'has an :ok HTTP status' do
      edit
      expect(response).to have_http_status(:ok)
    end
  end
end
