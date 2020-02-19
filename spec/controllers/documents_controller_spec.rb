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

    context "when failed" do
      it "gives an error feedback to the user" do
        post :create, params: { document: { random: 'whatever' } }

        expect(flash[:error]).to eq I18n.t('activerecord.errors.messages.creation_fail',
                                           model: Document.model_name.singular)
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
