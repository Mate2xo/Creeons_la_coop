require 'rails_helper'

RSpec.feature "DocumentUploadsAtInfoSections", type: :feature do
  before { sign_in create(:member, :admin) }

  context "when an admin uploads a document" do
    before {
      visit infos_path(anchor: 'documents')
      attach_file('document_file', Rails.root.join('spec', 'support', 'fixtures', 'erd.pdf'))
      click_button "Ajouter"
    }

    it "show the document on the infos/index#document view" do
      expect(page).to have_content 'erd.pdf'
    end

    context 'when javascript is enabled in the browser', js: true do
      it "show the document on the infos/index#document view" do
        expect(page).to have_content 'erd.pdf'
      end
    end
  end

  context "when an admin deletes a document" do
    before {
      create :document, :with_file
      visit infos_path(anchor: 'documents')
      click_on "Supprimer"
    }

    it "deletes the document from infos/index#document view" do
      expect(page).not_to have_content 'erd.pdf'
    end

    context 'when javascript is enabled in the browser', js: true do
      it "deletes the document from from the infos/index#document view" do
        page.driver.browser.switch_to.alert.accept
        expect(page).not_to have_content 'erd.pdf'
      end
    end
  end
end
