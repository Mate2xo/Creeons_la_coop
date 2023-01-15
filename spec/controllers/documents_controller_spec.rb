# frozen_string_literal: true

require 'rails_helper'

RSpec.describe DocumentsController, type: :controller do

  before { sign_in create(:member, :admin) }

  context "when a document is uploaded" do
    context "successfully" do
      it "gives a confirmation feedback to the user" do
        post :create, params: { document: attributes_for(:document, :with_file) }

        expect(flash[:notice]).to eq I18n.t('activerecord.notices.messages.record_created',
                                            model: Document.model_name.singular)
      end
    end

    context "when it is an invalid content type" do
      before { post :create, params: { document: attributes_for(:document, :with_invalid_file_type) } }

      it "gives a 'invalid file type' feedback to the user" do
        expect(flash[:alert]).to eq(I18n.t('errors.format',
                                           attribute: Document.human_attribute_name(:file),
                                           message: I18n.t('errors.messages.content_type_invalid')))
      end

      # ActiveStorage in Rails 5.2 *immediatly* uploads files on assignment, even without using .save (thus without validation)
      # So additionnal deletion of attachements, blobs, and stored file is necessary on invalid files
      it "purges the attached file" do
        new_document_instance = @controller.instance_variable_get(:@document)

        expect(new_document_instance.file).not_to be_attached
        expect(ActiveStorage::Blob.count).to eq 0
      end
    end

    context "when no file is attached" do
      it "gives an 'no file attached' feedback to the user" do
        post :create, params: { document: { random: 'whatever' } }

        expect(flash[:alert]).to eq(I18n.t('errors.format',
                                           attribute: Document.human_attribute_name(:file),
                                           message: I18n.t('errors.messages.blank')))
      end
    end
  end

  context "when file is updated" do
    context "with valid params" do
      before do
        new_document = create :document, :with_file
        patch :update, params: { id: new_document.id, document: { category: Document.category.options.sample, file_name: "new_name"} }
        new_document.reload
      end

      it "gives confirmation feedback to the user" do
        expect(flash[:notice]).to eq I18n.t('activerecord.notices.messages.update_success')
      end
    end
  end

  context "when a document is deleted" do
    it "gives a confirmation feedback to the user" do
      document = create :document, :with_file

      delete :destroy, params: { id: document.id }

      expect(flash[:notice]).to eq I18n.t('activerecord.notices.messages.record_destroyed',
                                          model: Document.model_name.singular)
    end
  end
end
