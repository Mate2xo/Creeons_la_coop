# frozen_string_literal: true

require 'rails_helper'

RSpec.feature "DocumentUploadsAtInfoSections", type: :feature do
  let(:admin) { create :member, :admin }

  context "when a regular member accesses the page" do
    before { sign_in create :member }

    it "does not show the document upload form" do
      visit infos_path(anchor: 'documents')

      expect(page).not_to have_content("Ajouter un document")
    end

    it "does not show the delete button on a document" do
      create :document, :with_file

      visit infos_path(anchor: 'documents')

      expect(page).not_to have_link(I18n.t('main_app.views.application.buttons.destroy'))
    end
  end

  context "when an admin uploads a document" do
    before {
      sign_in admin
      visit documents_path(anchor: 'documents')
      attach_file('document_file', Rails.root.join('spec', 'support', 'fixtures', 'erd.pdf'))
      click_button "Ajouter"
    }

    it "show the document on the documents/index#document view" do
      expect(page).to have_content 'erd.pdf'
    end

    context 'when javascript is enabled in the browser', js: true do
      it "show the document on the documents/index#document view" do
        expect(page).to have_content 'erd.pdf'
      end
    end
  end

  context "when an admin deletes a document" do
    before {
      sign_in admin
      create :document, :with_file
      visit documents_path(anchor: 'documents')
      click_on I18n.t("main_app.views.application.buttons.destroy")
    }

    it "deletes the document from documents/index#document view" do
      expect(page).not_to have_content 'erd.pdf'
    end

    context 'when javascript is enabled in the browser', js: true do
      it "deletes the document from from the documents/index#document view" do
        page.driver.browser.switch_to.alert.accept
        expect(page).not_to have_content 'erd.pdf'
      end
    end
  end
end
