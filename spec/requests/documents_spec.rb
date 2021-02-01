# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Document request', type: :request do
  let(:member) { create :member }

  describe 'GET index' do
    subject(:get_documents) { get documents_path }

    context 'when user is signed ?' do
      before { sign_in create :member }

      it 'renders the view' do
        create_list :document, 3, :with_file

        get_documents

        expect(response).to be_successful
      end
    end

    context 'when user is not signed ?' do
      it 'renders the view' do
        create_list :document, 3, :with_file, published: true
        get_documents

        expect(response).to be_successful
      end

      it "doesn't rend the documents with published attribute set to false" do
        create_list :document, 3, :with_file, published: true
        not_published_document = create :document, :with_file, published: false

        get_documents

        expect(controller.instance_variable_get('@documents')).not_to include(not_published_document)
      end
    end
  end
end
