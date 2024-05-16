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
      before { post :create, params: params }

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

      # ActiveStorage in Rails 5.2 *immediatly* uploads files on assignment,
      # even without using .save (thus without validation)
      # So additionnal deletion of attachements, blobs, and stored file is necessary on invalid files
      it 'purges the attached file', :aggregate_failures do
        new_document_instance = @controller.instance_variable_get(:@document)

        expect(new_document_instance.file).not_to be_attached
        expect(ActiveStorage::Blob.count).to eq 0
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
