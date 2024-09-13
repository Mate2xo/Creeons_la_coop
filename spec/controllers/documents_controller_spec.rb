# frozen_string_literal: true

require 'rails_helper'

RSpec.describe DocumentsController, type: :controller do
  before { sign_in create(:member, :admin) }

  describe '#create' do
    subject(:create_document) { post :create, params: params }

    let(:params) { {document: attributes_for(:document)} }

    it 'gives a confirmation feedback to the user' do
      create_document

      expect(flash[:notice]).to eq I18n.t('activerecord.notices.messages.record_created',
                                          model: Document.model_name.singular)
    end

    context 'when it is an invalid content type' do
      let(:params) do
        {
          document: attributes_for(:document,
                                   file: fixture_file_upload(Rails.root.join('spec/support/fixtures/fixture.json'),
                                                             'application/json'))
        }
      end

      it "gives a 'invalid file type' feedback to the user" do
        create_document

        expect(flash[:alert]).to eq(I18n.t('errors.format',
                                           attribute: Document.human_attribute_name(:file),
                                           message: I18n.t('errors.messages.content_type_invalid')))
      end

      # ActiveStorage in Rails 5.2 *immediatly* uploaded files on assignment, before saving.
      # So additionnal deletion of attachements, blobs, and stored file was necessary on invalid files.
      # This was fixed on Rails 6, but we keep this test just because I'm paranoid
      # see https://github.com/rails/rails/pull/33303
      it 'does not upload the attached file', :aggregate_failures do
        expect { create_document }.not_to change ActiveStorage::Blob, :count
      end
    end

    context 'when no file is attached' do
      it "gives an 'no file attached' feedback to the user" do
        post :create, params: {document: {random: 'whatever'}}

        expect(flash[:alert]).to eq(I18n.t('errors.format',
                                           attribute: Document.human_attribute_name(:file),
                                           message: I18n.t('errors.messages.blank')))
      end
    end
  end

  context 'when a document is deleted' do
    it 'gives a confirmation feedback to the user' do
      document = create(:document)

      delete :destroy, params: {id: document.id}

      expect(flash[:notice]).to eq I18n.t('activerecord.notices.messages.record_destroyed',
                                          model: Document.model_name.singular)
    end
  end
end
